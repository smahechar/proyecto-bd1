from flask import Flask, request, jsonify, render_template, redirect, session, flash, Response
import mysql.connector
import os
from dotenv import load_dotenv
from werkzeug.security import generate_password_hash, check_password_hash
from datetime import datetime, date, time
from functools import wraps

load_dotenv()

app = Flask(__name__)
app.secret_key = os.getenv("SECRET_KEY", "tu-secret-key-super-segura-2025")

# 
# CONFIGURACIÓN DE BASE DE DATOS
# 
def get_db():
    return mysql.connector.connect(
        host=os.getenv("DB_HOST", "192.168.56.101"),
        user=os.getenv("DB_USER", "root"),
        password=os.getenv("DB_PASS", "sistemas2024"),
        database=os.getenv("DB_NAME", "bdatos1"),
        autocommit=False
    )

# 
# DECORADORES
# 
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "user_id" not in session:
            flash("Debes iniciar sesión", "warning")
            return redirect("/login")
        return f(*args, **kwargs)
    return decorated_function

def admin_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        if "user_id" not in session:
            return redirect("/login")
        if session.get("rol") != "Administrador":
            flash("No tienes permisos de administrador", "danger")
            return redirect("/")
        return f(*args, **kwargs)
    return decorated_function

def role_required(*roles):
    def decorator(f):
        @wraps(f)
        def wrapper(*args, **kwargs):
            user_rol = session.get("id_rol")

            # Si el usuario no está autenticado
            if "user_id" not in session:
                flash("Debes iniciar sesión", "warning")
                return redirect("/login")

            # Si el rol no está permitido en esta vista
            if user_rol not in roles:
                flash("No tienes permiso para acceder a esta sección.", "danger")
                return redirect("/home")

            return f(*args, **kwargs)
        return wrapper
    return decorator


# 
# UTILIDADES
# 
def dict_cursor(db):
    """Retorna un cursor que devuelve diccionarios"""
    cursor = db.cursor(dictionary=True)
    return cursor

def format_time(t):
    """Formatea un objeto time a string HH:MM"""
    if isinstance(t, time):
        return t.strftime("%H:%M")
    return str(t)

def format_date(d):
    """Formatea una fecha"""
    if isinstance(d, date):
        return d.strftime("%Y-%m-%d")
    return str(d)

def registrar_historial(db, id_espacio, estado_anterior, estado_nuevo, user_id):
    try:
        cur = db.cursor()

        sql = """
        INSERT INTO historial (
            id_espacio,
            estado_anterior,
            estado_nuevo,
            fecha_cambio,
            hora_cierre,
            hora_cambio,
            fecha_creacion,
            fecha_modificacion,
            responsable_cambio
        ) VALUES (
            %s, %s, %s, NOW(), NULL, NULL, NOW(), NOW(), %s
        )
        """

        cur.execute(sql, (id_espacio, estado_anterior, estado_nuevo, user_id))

    except Exception as e:
        print("ERROR registrando historial:", e)

    finally:
        cur.close()

@app.route("/api/reportes/historial")
@login_required
def exportar_historial():
    try:
        db = get_db()
        cur = dict_cursor(db)

        cur.execute("""
            SELECT 
                h.id_historial,
                h.id_espacio,
                e.nombre AS nombre_espacio,
                h.estado_anterior,
                h.estado_nuevo,
                h.fecha_cambio,
                h.hora_cambio,
                h.fecha_creacion,
                h.fecha_modificacion,
                u.nombre AS responsable
            FROM historial h
            LEFT JOIN espacio e ON h.id_espacio = e.id_espacio
            LEFT JOIN usuario u ON h.responsable_cambio = u.id_usuario
            ORDER BY h.fecha_cambio DESC
        """)

        rows = cur.fetchall()

        # Crear contenido CSV
        import csv
        import io

        salida = io.StringIO()
        writer = csv.writer(salida)

        # encabezados
        writer.writerow([
            "ID",
            "Espacio",
            "Acción (Anterior)",
            "Descripción (Nuevo)",
            "Fecha",
            "Hora",
            "Registrado",
            "Actualizado",
            "Responsable"
        ])

        for r in rows:
            writer.writerow([
                r["id_historial"],
                r["nombre_espacio"],
                r["estado_anterior"],
                r["estado_nuevo"],
                r["fecha_cambio"],
                r["hora_cambio"],
                r["fecha_creacion"],
                r["fecha_modificacion"],
                r["responsable"]
            ])

        output = salida.getvalue()
        salida.close()

        return Response(
            output,
            mimetype="text/csv",
            headers={
                "Content-Disposition":
                "attachment; filename=reporte_historial.csv"
            }
        )

    except Exception as e:
        print("ERROR exportando historial:", e)
        return jsonify({"ok": False, "error": "No se pudo generar el reporte"}), 500





# 
# RUTAS - ROLES
# 

@app.route("/admin/mantenimientos")
@login_required
@role_required(1)
def admin_mantenimientos():
    return render_template("admin_mantenimientos.html")


@app.route("/reservas/nueva")
@login_required
@role_required(1, 2)
def reservas_docente_y_admin():
    return render_template("nueva_reserva.html")


@app.route("/reservas")
@login_required
@role_required(1, 2, 3)
def reservas():
    return render_template("reservas.html")




# 
# RUTAS - PÁGINAS PRINCIPALES
# 
@app.route("/")
def index():
    """Redirige a login si no está autenticado"""
    if "user_id" not in session:
        return redirect("/login")
    return redirect("/home")

@app.route("/home")
@login_required
def home():
    """Página principal con mapa y calendario"""
    return render_template("main.html", 
                         user_name=session.get("nombre"),
                         user_rol=session.get("rol"))

@app.route("/api/reporte/historial")
@login_required
@admin_required
def generar_reporte_historial():
    """Genera un archivo CSV con el historial real"""

    db = get_db()
    cur = dict_cursor(db)

    cur.execute("""
        SELECT 
            h.id_historial,
            h.id_espacio,
            e.nombre AS espacio_nombre,
            h.estado_anterior,
            h.estado_nuevo,
            h.fecha_cambio,
            h.hora_cambio
        FROM historial h
        LEFT JOIN espacio e ON h.id_espacio = e.id_espacio
        ORDER BY h.fecha_cambio DESC, h.hora_cambio DESC
    """)

    filas = cur.fetchall()

    # Generar CSV
    from io import StringIO
    import csv

    output = StringIO()
    writer = csv.writer(output)

    # Encabezados
    writer.writerow([
        "ID Historial", "ID Espacio", "Espacio",
        "Estado Anterior", "Estado Nuevo",
        "Fecha Cambio", "Hora Cambio"
    ])

    # Datos
    for f in filas:
        writer.writerow([
            f["id_historial"],
            f["id_espacio"],
            f["espacio_nombre"],
            f["estado_anterior"],
            f["estado_nuevo"],
            f["fecha_cambio"],
            f["hora_cambio"]
        ])

    output.seek(0)

    # Enviar como archivo
    from flask import Response
    return Response(
        output.getvalue(),
        mimetype="text/csv",
        headers={
            "Content-Disposition": "attachment; filename=historial_sgec.csv"
        }
    )

@app.route("/api/reportes/reservas")
@login_required
def exportar_reporte_reservas():
    db = get_db()
    cur = dict_cursor(db)

    try:
        cur.execute("""
            SELECT 
                r.id_reserva,
                u.nombre AS usuario,
                e.nombre AS espacio,
                r.fecha_reserva,
                r.hora_inicio,
                r.hora_fin,
                r.estado_reserva
            FROM reserva r
            JOIN usuario u ON u.id_usuario = r.id_usuario
            JOIN espacio e ON e.id_espacio = r.id_espacio
            ORDER BY r.fecha_reserva DESC, r.hora_inicio
        """)

        reservas = cur.fetchall()

        # Convertir a CSV
        import csv
        from io import StringIO
        
        output = StringIO()
        writer = csv.writer(output)

        # Escribir encabezado
        writer.writerow([
            "ID", "Usuario", "Espacio", 
            "Fecha", "Hora Inicio", "Hora Fin", 
            "Estado"
        ])

        # Escribir registros
        for r in reservas:
            writer.writerow([
                r["id_reserva"],
                r["usuario"],
                r["espacio"],
                r["fecha_reserva"],
                r["hora_inicio"],
                r["hora_fin"],
                r["estado_reserva"]
            ])

        output.seek(0)

        # Responder archivo descargable
        from flask import Response
        return Response(
            output.getvalue(),
            mimetype="text/csv",
            headers={
                "Content-Disposition": "attachment; filename=reporte_reservas.csv"
            }
        )

    except Exception as e:
        print("Error exportando CSV:", e)
        return jsonify({"ok": False, "error": "Error generando reporte"}), 500
    
    finally:
        cur.close()
        db.close()


@app.route("/login")
def login_page():
    """Página de login"""
    if "user_id" in session:
        return redirect("/home")
    return render_template("login.html")

@app.route("/register")
def register_page():
    """Página de registro"""
    if "user_id" in session:
        return redirect("/home")
    return render_template("registro.html")

@app.route("/logout")
def logout():
    """Cerrar sesión"""
    session.clear()
    flash("Sesión cerrada exitosamente", "info")
    return redirect("/login")

@app.route("/api/reservas/<int:id_reserva>", methods=["DELETE"])
@admin_required
def eliminar_reserva(id_reserva):
    """
    Elimina una reserva (cualquier usuario) — solo administrador.
    """
    db = get_db()
    cur = db.cursor(dictionary=True)

    try:
        # Buscar la reserva primero
        cur.execute("""
            SELECT id_espacio
            FROM reserva
            WHERE id_reserva = %s
        """, (id_reserva,))
        row = cur.fetchone()

        if not row:
            return jsonify({"ok": False, "error": "Reserva no encontrada"}), 404

        id_espacio = row["id_espacio"]

        # Eliminar la reserva
        cur.execute("DELETE FROM reserva WHERE id_reserva = %s", (id_reserva,))

        # Registrar en historial
        registrar_historial(
            db,
            id_espacio,
            "Reserva eliminada",
            f"Reserva #{id_reserva} eliminada por administrador",
            session["user_id"]
        )

        db.commit()
        return jsonify({"ok": True})

    except Exception as e:
        db.rollback()
        print("Error eliminando reserva:", e)
        return jsonify({"ok": False, "error": "Error interno al eliminar"}), 500

    finally:
        cur.close()
        db.close()
@app.route("/api/admin/reservas/all")
@admin_required
def admin_reservas_all():
    conn = get_db()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT r.id_reserva,
               r.fecha_reserva,
               r.hora_inicio,
               r.hora_fin,
               u.nombre AS usuario,
               e.nombre AS espacio_nombre
        FROM reserva r
        JOIN usuario u ON r.id_usuario = u.id_usuario
        JOIN espacio e ON r.id_espacio = e.id_espacio
        ORDER BY r.fecha_reserva DESC, r.hora_inicio ASC
    """)

    rows = cursor.fetchall()
    cursor.close()
    conn.close()

    # Convertir horas a string para evitar timedelta
    for r in rows:
        r["hora_inicio"] = str(r["hora_inicio"])
        r["hora_fin"]    = str(r["hora_fin"])
        r["fecha_reserva"] = str(r["fecha_reserva"])

    return jsonify(rows)




# 
# API - AUTENTICACIÓN
# 
@app.route("/auth", methods=["POST"])
def login():
    """Autenticación de usuario"""
    correo = request.form.get("correo")
    contrasena = request.form.get("contrasena")
    rol_seleccionado = request.form.get("rol")

    if not correo or not contrasena:
        return jsonify({"ok": False, "msg": "Faltan datos"})

    db = get_db()
    cur = dict_cursor(db)

    try:
        cur.execute("""
            SELECT u.*, r.nombre_rol 
            FROM usuario u
            JOIN rol r ON r.id_rol = u.id_rol
            WHERE u.correo = %s
        """, (correo,))
        user = cur.fetchone()

        if not user:
            return jsonify({"ok": False, "msg": "Usuario no encontrado"})

        # Verificar rol
        if rol_seleccionado and user["nombre_rol"] != rol_seleccionado:
            return jsonify({"ok": False, "msg": "El rol seleccionado no coincide"})

        # Verificar contraseña
        if not check_password_hash(user["contrasena"], contrasena):
            return jsonify({"ok": False, "msg": "Contraseña incorrecta"})

        # Guardar sesión
        session["user_id"] = user["id_usuario"]
        session["nombre"] = user["nombre"]
        session["rol"] = user["nombre_rol"]

        # Registrar en log_acciones
        cur.execute(
            "INSERT INTO log_acciones (id_usuario, accion) VALUES (%s, %s)",
            (user["id_usuario"], f"Login exitoso desde {request.remote_addr}")
        )
        db.commit()

        return jsonify({"ok": True, "redirect": "/home"})

    except Exception as e:
        print(f"Error en login: {e}")
        return jsonify({"ok": False, "msg": "Error en el servidor"})
    finally:
        cur.close()
        db.close()

@app.route("/api/register", methods=["POST"])
def register():
    """Registro de nuevo usuario"""
    nombre = request.form.get("nombre")
    correo = request.form.get("correo")
    contrasena = request.form.get("contrasena")
    rol = request.form.get("rol", "Estudiante")

    if not nombre or not correo or not contrasena:
        return jsonify({"ok": False, "msg": "Faltan datos"})

    db = get_db()
    cur = dict_cursor(db)

    try:
        # Obtener id_rol
        cur.execute("SELECT id_rol FROM rol WHERE nombre_rol=%s", (rol,))
        row = cur.fetchone()
        if not row:
            return jsonify({"ok": False, "msg": "Rol inválido"})
        id_rol = row["id_rol"]

        # Hash de contraseña
        hashed = generate_password_hash(contrasena)

        # Insertar usuario
        cur.execute(
            "INSERT INTO usuario (id_rol, nombre, correo, contrasena) VALUES (%s,%s,%s,%s)",
            (id_rol, nombre, correo, hashed)
        )
        db.commit()
        
        return jsonify({"ok": True, "msg": "Usuario creado exitosamente"})

    except mysql.connector.IntegrityError:
        return jsonify({"ok": False, "msg": "El correo ya está registrado"})
    except Exception as e:
        print(f"Error en registro: {e}")
        return jsonify({"ok": False, "msg": "Error al crear usuario"})
    finally:
        cur.close()
        db.close()

# 
# API - ESPACIOS (CRUD COMPLETO)
# 
@app.route("/api/espacios")
@login_required
def get_espacios():
    """Obtener lista de espacios"""
    db = get_db()
    cur = dict_cursor(db)
    
    try:
        cur.execute("""
            SELECT id_espacio, nombre, estado, fecha_modificacion,
                   COALESCE(capacidad, 0) as capacidad,
                   COALESCE(descripcion, '') as descripcion
            FROM espacio
            ORDER BY nombre
        """)
        espacios = cur.fetchall()
        
        # Formatear fechas
        for esp in espacios:
            if esp.get('fecha_modificacion'):
                esp['fecha_modificacion'] = str(esp['fecha_modificacion'])
        
        return jsonify(espacios)
    finally:
        cur.close()
        db.close()

@app.route("/api/espacios/<int:id>")
@login_required
def get_espacio_detalle(id):
    """Obtener detalle de un espacio específico"""
    db = get_db()
    cur = dict_cursor(db)
    
    try:
        cur.execute("SELECT * FROM espacio WHERE id_espacio = %s", (id,))
        espacio = cur.fetchone()
        
        if not espacio:
            return jsonify({"error": "Espacio no encontrado"}), 404
        
        if espacio.get('fecha_modificacion'):
            espacio['fecha_modificacion'] = str(espacio['fecha_modificacion'])
        
        return jsonify(espacio)
    finally:
        cur.close()
        db.close()

@app.route("/api/espacios/crear", methods=["POST"])
@admin_required
def crear_espacio():
    """Crear nuevo espacio (solo admin)"""
    data = request.get_json() if request.is_json else request.form
    
    nombre = data.get("nombre")
    estado = data.get("estado", "Disponible")
    capacidad = data.get("capacidad", 0)
    descripcion = data.get("descripcion", "")
    
    if not nombre:
        return jsonify({"ok": False, "msg": "Falta el nombre"})
    
    db = get_db()
    cur = dict_cursor(db)
    
    try:
        cur.execute(
            "INSERT INTO espacio (nombre, estado, capacidad, descripcion) VALUES (%s, %s, %s, %s)",
            (nombre, estado, capacidad, descripcion)
        )
        id_espacio = cur.lastrowid
        
        # Registrar en historial
        registrar_historial(
            db, id_espacio, "Creación", 
            f"Espacio '{nombre}' creado", 
            session["user_id"]
        )
        
        db.commit()
        
        return jsonify({"ok": True, "msg": "Espacio creado", "id": id_espacio})
    except Exception as e:
        db.rollback()
        print(f"Error crear espacio: {e}")
        return jsonify({"ok": False, "msg": "Error al crear espacio"})
    finally:
        cur.close()
        db.close()

@app.route("/api/espacios/<int:id>/editar", methods=["PUT", "POST"])
@admin_required
def editar_espacio(id):
    """Editar espacio existente (solo admin)"""
    data = request.get_json() if request.is_json else request.form
    
    nombre = data.get("nombre")
    estado = data.get("estado")
    capacidad = data.get("capacidad")
    descripcion = data.get("descripcion")
    
    db = get_db()
    cur = dict_cursor(db)
    
    try:
        # Obtener datos actuales
        cur.execute("SELECT * FROM espacio WHERE id_espacio = %s", (id,))
        espacio_actual = cur.fetchone()
        
        if not espacio_actual:
            return jsonify({"ok": False, "msg": "Espacio no encontrado"}), 404
        
        # Construir query de actualización
        updates = []
        params = []
        cambios = []
        
        if nombre and nombre != espacio_actual['nombre']:
            updates.append("nombre = %s")
            params.append(nombre)
            cambios.append(f"Nombre: '{espacio_actual['nombre']}' → '{nombre}'")
        
        if estado and estado != espacio_actual['estado']:
            updates.append("estado = %s")
            params.append(estado)
            cambios.append(f"Estado: '{espacio_actual['estado']}' → '{estado}'")
        
        if capacidad is not None:
            updates.append("capacidad = %s")
            params.append(capacidad)
            cambios.append(f"Capacidad: {espacio_actual.get('capacidad', 0)} → {capacidad}")
        
        if descripcion is not None:
            updates.append("descripcion = %s")
            params.append(descripcion)
        
        if not updates:
            return jsonify({"ok": False, "msg": "No hay cambios para aplicar"})
        
        # Actualizar
        params.append(id)
        query = f"UPDATE espacio SET {', '.join(updates)} WHERE id_espacio = %s"
        cur.execute(query, params)
        
        # Registrar en historial
        if cambios:
            registrar_historial(
                db, id, "Modificación",
                "Cambios: " + "; ".join(cambios),
                session["user_id"]
            )
        
        db.commit()
        
        return jsonify({"ok": True, "msg": "Espacio actualizado"})
        
    except Exception as e:
        db.rollback()
        print(f"Error editar espacio: {e}")
        return jsonify({"ok": False, "msg": "Error al actualizar"}), 500
    finally:
        cur.close()
        db.close()

@app.route("/api/espacios/<int:id>/eliminar", methods=["DELETE", "POST"])
@admin_required
def eliminar_espacio(id):
    """Eliminar espacio (solo admin)"""
    db = get_db()
    cur = dict_cursor(db)
    
    try:
        # Verificar que existe
        cur.execute("SELECT nombre FROM espacio WHERE id_espacio = %s", (id,))
        espacio = cur.fetchone()
        
        if not espacio:
            return jsonify({"ok": False, "msg": "Espacio no encontrado"}), 404
        
        # Verificar si tiene reservas activas
        cur.execute("""
            SELECT COUNT(*) as total FROM reserva 
            WHERE id_espacio = %s 
            AND estado_reserva = 'Activa'
            AND fecha_reserva >= CURDATE()
        """, (id,))
        
        if cur.fetchone()['total'] > 0:
            return jsonify({
                "ok": False, 
                "msg": "No se puede eliminar: tiene reservas activas"
            }), 400
        
        # Registrar en historial antes de eliminar
        registrar_historial(
            db, id, "Eliminación",
            f"Espacio '{espacio['nombre']}' eliminado",
            session["user_id"]
        )
        
        # Eliminar
        cur.execute("DELETE FROM espacio WHERE id_espacio = %s", (id,))
        db.commit()
        
        return jsonify({"ok": True, "msg": "Espacio eliminado"})
        
    except Exception as e:
        db.rollback()
        print(f"Error eliminar espacio: {e}")
        return jsonify({"ok": False, "msg": "Error al eliminar"}), 500
    finally:
        cur.close()
        db.close()

# 
# API - RESERVAS
# 
@app.route("/api/reservas")
@login_required
def get_reservas():
    """Obtener reservas (filtradas por usuario si no es admin)"""
    db = get_db()
    cur = dict_cursor(db)
    
    try:
        if session.get("rol") == "Administrador":
            # Admin ve todas las reservas
            cur.execute("""
                SELECT r.*, 
                       u.nombre as usuario_nombre,
                       e.nombre as espacio_nombre
                FROM reserva r
                JOIN usuario u ON r.id_usuario = u.id_usuario
                JOIN espacio e ON r.id_espacio = e.id_espacio
                WHERE r.fecha_reserva >= CURDATE() - INTERVAL 7 DAY
                ORDER BY r.fecha_reserva DESC, r.hora_inicio DESC
                LIMIT 100
            """)
        else:
            # Usuario normal solo ve sus reservas
            cur.execute("""
                SELECT r.*, 
                       u.nombre as usuario_nombre,
                       e.nombre as espacio_nombre
                FROM reserva r
                JOIN usuario u ON r.id_usuario = u.id_usuario
                JOIN espacio e ON r.id_espacio = e.id_espacio
                WHERE r.id_usuario = %s
                  AND r.fecha_reserva >= CURDATE() - INTERVAL 30 DAY
                ORDER BY r.fecha_reserva DESC, r.hora_inicio DESC
                LIMIT 50
            """, (session["user_id"],))
        
        reservas = cur.fetchall()
        
        # Formatear para JSON
        for res in reservas:
            res['fecha_reserva'] = format_date(res['fecha_reserva'])
            res['hora_inicio'] = format_time(res['hora_inicio'])
            res['hora_fin'] = format_time(res['hora_fin'])
            if res.get('fecha_creacion'):
                res['fecha_creacion'] = str(res['fecha_creacion'])
        
        return jsonify(reservas)
    finally:
        cur.close()
        db.close()

@app.route("/api/mantenimientos/eliminar/<int:id_mantenimiento>", methods=["DELETE"])
@admin_required
def eliminar_mantenimiento(id_mantenimiento):
    db = get_db()
    cur = dict_cursor(db)

    try:
        # Obtener mantenimiento
        cur.execute("SELECT * FROM mantenimiento WHERE id_mantenimiento = %s", (id_mantenimiento,))
        mant = cur.fetchone()

        if not mant:
            return jsonify({"ok": False, "error": "Mantenimiento no encontrado"}), 404

        id_espacio = mant["id_espacio"]

        # Eliminar mantenimiento
        cur.execute("DELETE FROM mantenimiento WHERE id_mantenimiento = %s", (id_mantenimiento,))

        # Verificar si quedan mantenimientos activos
        cur.execute("""
            SELECT COUNT(*) AS total
            FROM mantenimiento
            WHERE id_espacio = %s
              AND estado_mantenimiento = 'Programado'
        """, (id_espacio,))
        quedan = cur.fetchone()["total"]

        # Si no quedan, liberar espacio
        if quedan == 0:
            cur.execute("""
                UPDATE espacio SET estado = 'Disponible'
                WHERE id_espacio = %s
            """, (id_espacio,))

        db.commit()

        # Registrar historial
        registrar_historial(
            db,
            id_espacio,
            "Mantenimiento eliminado",
            f"Se eliminó el mantenimiento #{id_mantenimiento}",
            session["user_id"]
        )

        return jsonify({"ok": True})

    except Exception as e:
        db.rollback()
        return jsonify({"ok": False, "error": str(e)})

    finally:
        cur.close()
        db.close()


@app.route("/api/reservas/proximas")
@login_required
def get_reservas_proximas():
    """Obtener próximas reservas del usuario"""
    db = get_db()
    cur = dict_cursor(db)
    
    try:
        cur.execute("""
            SELECT r.*, e.nombre as espacio_nombre
            FROM reserva r
            JOIN espacio e ON r.id_espacio = e.id_espacio
            WHERE r.id_usuario = %s
              AND r.estado_reserva = 'Activa'
              AND CONCAT(r.fecha_reserva, ' ', r.hora_inicio) >= NOW()
            ORDER BY r.fecha_reserva, r.hora_inicio
            LIMIT 5
        """, (session["user_id"],))
        
        reservas = cur.fetchall()
        
        for res in reservas:
            res['fecha_reserva'] = format_date(res['fecha_reserva'])
            res['hora_inicio'] = format_time(res['hora_inicio'])
            res['hora_fin'] = format_time(res['hora_fin'])
        
        return jsonify(reservas)
    finally:
        cur.close()
        db.close()

@app.route("/api/reservas", methods=["POST"])
@login_required
def crear_reserva():
    """Crear nueva reserva usando procedimiento almacenado"""
    data = request.get_json()
    
    id_espacio = data.get("id_espacio")
    fecha_reserva = data.get("fecha_reserva")
    hora_inicio = data.get("hora_inicio")
    hora_fin = data.get("hora_fin")
    
    if not all([id_espacio, fecha_reserva, hora_inicio, hora_fin]):
        return jsonify({"ok": False, "error": "Faltan datos obligatorios"}), 400
    
    db = get_db()
    cur = db.cursor()
    cur_dict = dict_cursor(db)

    # Verificar si la sala está en mantenimiento ese día
    cur.execute("""
    SELECT *
    FROM mantenimiento
    WHERE id_espacio = %s
      AND fecha_inicio <= %s
      AND fecha_fin >= %s
    """, (id_espacio, fecha_reserva, fecha_reserva))

    mant = cur.fetchone()

    if mant:
        return jsonify({
            "ok": False,
            "error": "El espacio está en mantenimiento en esta fecha."
        }), 400

    
    try:
        # Obtener nombre del espacio
        cur_dict.execute("SELECT nombre FROM espacio WHERE id_espacio = %s", (id_espacio,))
        espacio = cur_dict.fetchone()
        espacio_nombre = espacio['nombre'] if espacio else f"Espacio #{id_espacio}"
        
        # Llamar al procedimiento almacenado
        cur.callproc('crear_reserva', [
            session["user_id"],
            id_espacio,
            fecha_reserva,
            hora_inicio,
            hora_fin
        ])
        
        # Registrar en historial
        registrar_historial(
            db, id_espacio, "Reserva",
            f"Reserva creada para {fecha_reserva} de {hora_inicio} a {hora_fin}",
            session["user_id"]
        )
        
        db.commit()
        
        return jsonify({
            "ok": True, 
            "msg": "Reserva creada exitosamente"
        })
        
    except mysql.connector.Error as e:
        db.rollback()
        print("🔥 ERROR MYSQL AL CREAR RESERVA:", e)
        error_msg = str(e)

        
        # Extraer mensaje de error personalizado
        if "Conflicto" in error_msg or "reservado" in error_msg:
            return jsonify({
                "ok": False, 
                "error": "El espacio ya está reservado en ese horario"
            }), 409
        elif "Hora fin" in error_msg:
            return jsonify({
                "ok": False, 
                "error": "La hora de fin debe ser posterior a la hora de inicio"
            }), 400
        else:
            return jsonify({
                "ok": False, 
                "error": "Error al crear la reserva"
            }), 500
    finally:
        cur.close()
        cur_dict.close()
        db.close()

@app.route("/api/historial")
@admin_required
def ver_historial():
    """Vista HTML simple del historial (solo admin)"""
    db = get_db()
    cur = dict_cursor(db)

    try:
        cur.execute("""
            SELECT 
                h.id_historial,
                h.fecha_cambio,
                h.hora_cambio,
                e.nombre AS espacio_nombre,
                h.estado_anterior,
                h.estado_nuevo,
                h.responsable_cambio
            FROM historial h
            JOIN espacio e ON e.id_espacio = h.id_espacio
            ORDER BY h.fecha_cambio DESC, h.hora_cambio DESC
            LIMIT 300
        """)
        filas = cur.fetchall()
    finally:
        cur.close()
        db.close()

    filas_html = "".join(
        f"""
        <tr>
          <td>{f['id_historial']}</td>
          <td>{f['fecha_cambio']} {f.get('hora_cambio','') or ''}</td>
          <td>{f['espacio_nombre']}</td>
          <td>{f['estado_anterior']}</td>
          <td>{f['estado_nuevo']}</td>
          <td>{f.get('responsable_cambio') or '-'}</td>
        </tr>
        """
        for f in filas
    )

    return f"""
    <!DOCTYPE html>
    <html lang="es">
    <head>
      <meta charset="utf-8">
      <title>Historial SGEC</title>
      <style>
        body {{
          font-family: system-ui, -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
          background: #071023;
          color: #e6f2ff;
          padding: 20px;
        }}
        h1 {{
          margin-bottom: 16px;
        }}
        table {{
          width: 100%;
          border-collapse: collapse;
          background: #0f1b2b;
        }}
        th, td {{
          border: 1px solid #22344b;
          padding: 8px;
          font-size: 13px;
        }}
        th {{
          background: #13233a;
        }}
        tr:nth-child(even) {{
          background: #101b30;
        }}
      </style>
    </head>
    <body>
      <h1>Historial de cambios SGEC</h1>
      <table>
        <thead>
          <tr>
            <th>ID</th>
            <th>Fecha / Hora</th>
            <th>Espacio</th>
            <th>Acción</th>
            <th>Detalle</th>
            <th>Responsable</th>
          </tr>
        </thead>
        <tbody>
          {filas_html or '<tr><td colspan="6">Sin registros</td></tr>'}
        </tbody>
      </table>
    </body>
    </html>
    """


@app.route("/api/reservas/<int:id>/cancelar", methods=["POST"])
@login_required
def cancelar_reserva(id):
    """Cancelar una reserva"""
    db = get_db()
    cur = dict_cursor(db)
    
    try:
        # Verificar que la reserva existe y pertenece al usuario (o es admin)
        cur.execute(
            "SELECT r.*, e.nombre as espacio_nombre FROM reserva r JOIN espacio e ON r.id_espacio = e.id_espacio WHERE r.id_reserva = %s", 
            (id,)
        )
        reserva = cur.fetchone()
        
        if not reserva:
            return jsonify({"ok": False, "error": "Reserva no encontrada"}), 404
        
        # Verificar permisos
        if reserva["id_usuario"] != session["user_id"] and session.get("rol") != "Administrador":
            return jsonify({"ok": False, "error": "No tienes permisos"}), 403
        
        # Cancelar reserva
        cur.execute(
            "UPDATE reserva SET estado_reserva = 'Cancelada' WHERE id_reserva = %s",
            (id,)
        )
        
        # Registrar en historial
        registrar_historial(
            db, reserva['id_espacio'], "Cancelación",
            f"Reserva #{id} cancelada ({reserva['fecha_reserva']} {reserva['hora_inicio']}-{reserva['hora_fin']})",
            session["user_id"]
        )
        
        # Registrar en log
        cur.execute(
            "INSERT INTO log_acciones (id_usuario, accion) VALUES (%s, %s)",
            (session["user_id"], f"Canceló reserva #{id}")
        )
        
        db.commit()
        
        return jsonify({"ok": True, "msg": "Reserva cancelada"})
        
    except Exception as e:
        db.rollback()
        print(f"Error cancelar reserva: {e}")
        return jsonify({"ok": False, "error": "Error al cancelar"}), 500
    finally:
        cur.close()
        db.close()


# API - MANTENIMIENTOS

@app.route("/api/mantenimientos")
@admin_required
def get_mantenimientos():
    """Obtener lista de mantenimientos (solo admin)"""
    db = get_db()
    cur = dict_cursor(db)
    
    try:
        cur.execute("""
            SELECT m.*, 
                   e.nombre as espacio_nombre,
                   u.nombre as usuario_nombre
            FROM mantenimiento m
            JOIN espacio e ON m.id_espacio = e.id_espacio
            JOIN usuario u ON m.id_usuario = u.id_usuario
            ORDER BY m.fecha_creacion DESC
            LIMIT 50
        """)
        
        mantenimientos = cur.fetchall()
        
        for mant in mantenimientos:
            if mant.get('fecha_creacion'):
                mant['fecha_creacion'] = str(mant['fecha_creacion'])
        
        return jsonify(mantenimientos)
    finally:
        cur.close()
        db.close()

@app.route("/api/mantenimientos/crear", methods=["POST"])
@admin_required
def crear_mantenimiento():
    """Crear mantenimiento (solo admin)"""
    data = request.get_json()
    
    id_espacio = data.get("id_espacio")
    descripcion = data.get("descripcion", "")
    estado = data.get("estado", "Programado")
    
    if not id_espacio:
        return jsonify({"ok": False, "error": "Falta id_espacio"}), 400
    
    db = get_db()
    cur = dict_cursor(db)
    
    try:
        cur.execute("""
            INSERT INTO mantenimiento 
            (id_usuario, id_espacio, descripcion, estado_mantenimiento)
            VALUES (%s, %s, %s, %s)
        """, (session["user_id"], id_espacio, descripcion, estado))
        
        id_mant = cur.lastrowid
        
        # Registrar en historial
        registrar_historial(
            db, id_espacio, "Mantenimiento",
            f"Mantenimiento programado: {descripcion}",
            session["user_id"]
        )
        
        db.commit()
        
        return jsonify({
            "ok": True, 
            "msg": "Mantenimiento programado",
            "id": id_mant
        })
        
    except Exception as e:
        db.rollback()
        print(f"Error crear mantenimiento: {e}")
        return jsonify({"ok": False, "error": "Error al crear"}), 500
    finally:
        cur.close()
        db.close()


# API - DASHBOARD Y ESTADÍSTICAS

@app.route("/api/dashboard")
@login_required
def get_dashboard():
    """Obtener datos para el dashboard"""
    db = get_db()
    cur = dict_cursor(db)
    
    try:
        stats = {}
        
        # Total de espacios
        cur.execute("SELECT COUNT(*) as total FROM espacio")
        stats["espacios"] = cur.fetchone()["total"]
        
        # Espacios disponibles
        cur.execute("SELECT COUNT(*) as total FROM espacio WHERE estado = 'Disponible'")
        stats["espacios_disponibles"] = cur.fetchone()["total"]
        
        # Reservas de hoy
        cur.execute("""
            SELECT COUNT(*) as total 
            FROM reserva 
            WHERE fecha_reserva = CURDATE() AND estado_reserva = 'Activa'
        """)
        stats["reservas_hoy"] = cur.fetchone()["total"]
        
        # Mis reservas activas
        cur.execute("""
            SELECT COUNT(*) as total 
            FROM reserva 
            WHERE id_usuario = %s 
              AND estado_reserva = 'Activa'
              AND fecha_reserva >= CURDATE()
        """, (session["user_id"],))
        stats["mis_reservas"] = cur.fetchone()["total"]
        
        # Si es admin, estadísticas adicionales
        if session.get("rol") == "Administrador":
            cur.execute("SELECT COUNT(*) as total FROM usuario")
            stats["usuarios"] = cur.fetchone()["total"]
            
            cur.execute("""
                SELECT COUNT(*) as total 
                FROM mantenimiento 
                WHERE estado_mantenimiento IN ('Programado', 'En Proceso')
            """)
            stats["mantenimientos_pendientes"] = cur.fetchone()["total"]
        
        return jsonify(stats)
        
    finally:
        cur.close()
        db.close()

@app.route("/api/historial")
@admin_required
def get_historial():
    """Obtener historial de cambios (solo admin)"""
    db = get_db()
    cur = dict_cursor(db)
    
    try:
        cur.execute("""
            SELECT h.*, 
                   e.nombre as espacio_nombre,
                   u.nombre as usuario_nombre
            FROM historial h
            JOIN espacio e ON h.id_espacio = e.id_espacio
            LEFT JOIN usuario u ON h.responsable_cambio = u.id_usuario
            ORDER BY h.fecha_cambio DESC
            LIMIT 100
        """)
        
        historial = cur.fetchall()
        
        for item in historial:
            if item.get('fecha_cambio'):
                item['fecha_cambio'] = str(item['fecha_cambio'])
        
        return jsonify(historial)
    finally:
        cur.close()
        db.close()

# 
# API - USUARIOS (ADMIN)
# 
@app.route("/api/usuarios")
@admin_required
def get_usuarios():
    """Obtener lista de usuarios (solo admin)"""
    db = get_db()
    cur = dict_cursor(db)
    
    try:
        cur.execute("""
            SELECT u.id_usuario, u.nombre, u.correo, 
                   r.nombre_rol, u.fecha_creacion
            FROM usuario u
            JOIN rol r ON u.id_rol = r.id_rol
            ORDER BY u.fecha_creacion DESC
        """)
        
        usuarios = cur.fetchall()
        
        for usr in usuarios:
            if usr.get('fecha_creacion'):
                usr['fecha_creacion'] = str(usr['fecha_creacion'])
        
        return jsonify(usuarios)
    finally:
        cur.close()
        db.close()

# 
# MANEJO DE ERRORES
# 
@app.errorhandler(404)
def not_found(e):
    return render_template("404.html"), 404

@app.errorhandler(500)
def server_error(e):
    return render_template("500.html"), 500

# 
# EJECUTAR APLICACIÓN
# 
if __name__ == "__main__":
    print("""
    ╔═══════════════════════════════════════════════════════╗
    ║        Sistema de Gestión de Espacios                 ║
    ║            Universidad El Bosque                      ║
    ╚═══════════════════════════════════════════════════════╝
    
     Servidor iniciado en: http://localhost:5000
     Base de datos: bdatos1
    """)
    
    app.run(
        host="0.0.0.0",
        port=5000,
        debug=True
    )