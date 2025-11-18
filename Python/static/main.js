// ===============================
// SGEC - FRONT DASHBOARD
// ===============================

let ESPACIOS = [];
let BLOQUE_SELECCIONADO = null;
let RESERVAS_PROX = [];

// Rol del usuario obtenido del HTML
const USER_ROLE = document.querySelector(".user-name")?.dataset.userRol || "Estudiante";

document.addEventListener("DOMContentLoaded", () => {
  initDashboard();
});

async function initDashboard() {
  await Promise.all([
    cargarEspacios(),
    cargarDashboard(),
    cargarReservasProximas()
  ]);

  renderCalendar();
  wireModal();
}

async function deleteMaintenance() {
    const id = document.getElementById("mMantenimientoId").value;

    if (!confirm("¿Seguro que quieres eliminar este mantenimiento?")) return;

    const resp = await fetch(`/api/mantenimientos/eliminar/${id}`, {
        method: "DELETE"
    });

    const data = await resp.json();

    if (data.ok) {
        alert("Mantenimiento eliminado");
        closeMaintenanceModal();
        cargarEspacios();
    } else {
        alert("Error: " + data.error);
    }
}


// ===============================
// CARGA DE DATOS
// ===============================

async function cargarEspacios() {
  try {
    const res = await fetch("/api/espacios");
    if (!res.ok) throw new Error("Error al cargar espacios");
    ESPACIOS = await res.json();

    renderRoomList();
    renderEspaciosSelect();
    renderMapaBloques();
  } catch (err) {
    console.error(err);
  }
}

async function eliminarReserva(id_reserva) {
  if (!confirm("¿Seguro que deseas eliminar esta reserva?")) return;

  const resp = await fetch(`/api/reservas/${id_reserva}/eliminar`, {
    method: "DELETE"
  });

  const data = await resp.json();

  if (data.ok) {
    alert("Reserva eliminada correctamente");
    cargarReservas();  // refrescar reservaciones
    cargarEspacios();  // refrescar estados del mapa/lista
  } else {
    alert("Error: " + data.error);
  }
}


async function cargarDashboard() {
  try {
    const res = await fetch("/api/dashboard");
    if (!res.ok) throw new Error("Error al cargar dashboard");
    const stats = await res.json();

    setText("statEspacios", stats.espacios ?? 0);
    setText("statDisponibles", stats.espacios_disponibles ?? 0);
    setText("statHoy", stats.reservas_hoy ?? 0);
    setText("statMias", stats.mis_reservas ?? 0);
  } catch (err) {
    console.error(err);
  }
}

async function cargarReservasProximas() {
  try {
    const res = await fetch("/api/reservas/proximas");
    if (!res.ok) throw new Error("Error al cargar próximas reservas");
    RESERVAS_PROX = await res.json();
    renderUpcomingList();
  } catch (err) {
    console.error(err);
  }
}

// ===============================
// UTILIDADES DOM
// ===============================

function $(sel) {
  return document.querySelector(sel);
}

function setText(id, value) {
  const el = document.getElementById(id);
  if (el) el.textContent = value;
}

// ===============================
// LISTA DE ESPACIOS (COLUMNA IZQUIERDA)
// ===============================

function getBloqueDeNombre(nombre) {
  if (!nombre || typeof nombre !== "string") return null;
  return nombre.trim()[0].toUpperCase();
}

function espaciosFiltradosPorBloque() {
  if (!BLOQUE_SELECCIONADO) return ESPACIOS;
  return ESPACIOS.filter(e => getBloqueDeNombre(e.nombre) === BLOQUE_SELECCIONADO);
}

function renderRoomList() {
  const cont = document.getElementById("roomList");
  if (!cont) return;

  const searchValue = (document.getElementById("searchEspacio")?.value || "").toLowerCase();
  let data = espaciosFiltradosPorBloque();

  if (searchValue) {
    data = data.filter(e =>
      e.nombre.toLowerCase().includes(searchValue) ||
      (e.descripcion || "").toLowerCase().includes(searchValue)
    );
  }

  if (!data.length) {
    cont.innerHTML = `<div style="font-size:13px;color:var(--muted)">No hay espacios para el filtro actual.</div>`;
    return;
  }

  cont.innerHTML = data.map(e => {
    const estado = (e.estado || "Disponible").toLowerCase();

    let dotClass = "disponible";
    let disabledClass = "";
    let clickAction = `onclick="handleRoomClick(${e.id_espacio})"`;

    // Si está en mantenimiento → bloquear sala
    if (estado.includes("manten")) {
      dotClass = "mantenimiento";
      disabledClass = "room-disabled";
      clickAction = ""; // evita abrir el modal de reservas
    }
    else if (!estado.includes("dispon")) {
      dotClass = "ocupado";
    }

    return `
      <div class="room ${disabledClass}">
        <div class="room-main" ${clickAction}>
          <div class="dot ${dotClass}"></div>
          <div>
            <strong>${e.nombre}</strong>
            <div class="meta">
              Estado: ${e.estado}<br>
              Capacidad: ${e.capacidad ?? "-"}
            </div>
          </div>
        </div>

        ${
          USER_ROLE === "Administrador"
            ? `
              <button class="btn btn-small"
                      style="margin-top:6px"
                      onclick="openMaintenanceModal(${e.id_espacio})">
                🛠 Mantenimiento
              </button>
            `
            : ""
        }
      </div>
    `;
  }).join("");
}


// búsqueda por texto
const searchInput = document.getElementById("searchEspacio");
if (searchInput) {
  searchInput.addEventListener("input", () => renderRoomList());
}

// ===============================
// MANTENIMIENTO - MODAL
// ===============================

function openMaintenanceModal(idEspacio) {
  const idInput = document.getElementById("mEspacioId");
  const modal = document.getElementById("modalMantenimiento");

  if (!idInput || !modal) return;

  idInput.value = idEspacio;
  modal.classList.add("show");
}

function closeMaintenanceModal() {
  const modal = document.getElementById("modalMantenimiento");
  if (!modal) return;
  modal.classList.remove("show");
}

// ===============================
// SELECT DE ESPACIOS EN EL MODAL
// ===============================

function renderEspaciosSelect() {
  const sel = document.getElementById("fEspacio");
  if (!sel) return;

  const data = espaciosFiltradosPorBloque();

  sel.innerHTML = `
    <option value="">Selecciona un espacio...</option>
    ${data.map(e => `<option value="${e.id_espacio}">${e.nombre} - ${e.descripcion || ""}</option>`).join("")}
  `;
}

// ===============================
// MAPA SVG DE BLOQUES (COLUMNA CENTRAL)
// ===============================

function renderMapaBloques() {
  const cont = document.getElementById("mapaSvg");
  if (!cont) return;

  const svg = `
    <svg viewBox="0 0 1200 820" class="campus-svg">

      <!-- FILA SUPERIOR -->
      <g data-bloque="C" class="bloque-group">
        <rect x="150" y="80" width="120" height="120" class="bloque-shape" />
        <text x="210" y="150" text-anchor="middle" class="bloque-label">C</text>
      </g>

      <g data-bloque="D" class="bloque-group">
        <rect x="300" y="80" width="120" height="120" class="bloque-shape" />
        <text x="360" y="150" text-anchor="middle" class="bloque-label">D</text>
      </g>

      <g data-bloque="E" class="bloque-group">
        <rect x="450" y="80" width="120" height="120" class="bloque-shape" />
        <text x="510" y="150" text-anchor="middle" class="bloque-label">E</text>
      </g>

      <g data-bloque="F" class="bloque-group">
        <rect x="600" y="80" width="120" height="120" class="bloque-shape" />
        <text x="660" y="150" text-anchor="middle" class="bloque-label">F</text>
      </g>

      <g data-bloque="G" class="bloque-group">
        <rect x="750" y="80" width="120" height="120" class="bloque-shape" />
        <text x="810" y="150" text-anchor="middle" class="bloque-label">G</text>
      </g>

      <g data-bloque="H" class="bloque-group">
        <rect x="900" y="80" width="120" height="120" class="bloque-shape" />
        <text x="960" y="150" text-anchor="middle" class="bloque-label">H</text>
      </g>

      <!-- FILA MEDIA SUPERIOR -->
      <g data-bloque="M" class="bloque-group">
        <rect x="380" y="250" width="440" height="120" class="bloque-shape" />
        <text x="600" y="320" text-anchor="middle" class="bloque-label">M</text>
      </g>

      <!-- FILA INTERMEDIA -->
      <g data-bloque="B" class="bloque-group">
        <rect x="150" y="420" width="180" height="140" class="bloque-shape" />
        <text x="240" y="500" text-anchor="middle" class="bloque-label">B</text>
      </g>

      <g data-bloque="I" class="bloque-group">
        <rect x="380" y="430" width="440" height="90" class="bloque-shape" />
        <text x="600" y="485" text-anchor="middle" class="bloque-label">I</text>
      </g>

      <g data-bloque="J" class="bloque-group">
        <rect x="850" y="420" width="180" height="140" class="bloque-shape" />
        <text x="940" y="500" text-anchor="middle" class="bloque-label">J</text>
      </g>

      <!-- FILA INFERIOR -->
      <g data-bloque="A" class="bloque-group">
        <rect x="150" y="600" width="160" height="120" class="bloque-shape" />
        <text x="230" y="670" text-anchor="middle" class="bloque-label">A</text>
      </g>

      <g data-bloque="L" class="bloque-group">
        <rect x="360" y="590" width="250" height="130" class="bloque-shape" />
        <text x="485" y="660" text-anchor="middle" class="bloque-label">L</text>
      </g>

      <g data-bloque="K" class="bloque-group">
        <rect x="650" y="600" width="160" height="120" class="bloque-shape" />
        <text x="730" y="670" text-anchor="middle" class="bloque-label">K</text>
      </g>

      <g data-bloque="N" class="bloque-group">
        <rect x="850" y="600" width="160" height="120" class="bloque-shape" />
        <text x="930" y="670" text-anchor="middle" class="bloque-label">N</text>
      </g>

      <!-- BLOQUE O -->
      <g data-bloque="O" class="bloque-group">
        <rect x="550" y="740" width="120" height="60" class="bloque-shape" />
        <text x="610" y="780" text-anchor="middle" class="bloque-label">O</text>
      </g>

    </svg>
  `;

  cont.innerHTML = svg;

  // Marcar el bloque seleccionado
  if (BLOQUE_SELECCIONADO) {
    const sel = cont.querySelector(`[data-bloque="${BLOQUE_SELECCIONADO}"]`);
    if (sel) sel.classList.add("selected");
  }

  // Activar clics
  cont.querySelectorAll("[data-bloque]").forEach(el => {
    el.addEventListener("click", () => {
      seleccionarBloque(el.dataset.bloque);
    });
  });
}

function seleccionarBloque(bloqueId) {
  if (BLOQUE_SELECCIONADO === bloqueId) {
    BLOQUE_SELECCIONADO = null;
  } else {
    BLOQUE_SELECCIONADO = bloqueId;
  }

  renderMapaBloques();
  renderRoomList();
  renderEspaciosSelect();
}

// ===============================
// CALENDARIO SEMANAL
// ===============================

function renderCalendar() {
  const cont = document.getElementById("calendar");
  if (!cont) return;

  const hoy = new Date();
  const diasSemana = [];

  for (let i = 0; i < 7; i++) {
    const d = new Date(hoy);
    d.setDate(hoy.getDate() + i);
    diasSemana.push(d);
  }

  const nombres = ["Dom", "Lun", "Mar", "Mié", "Jue", "Vie", "Sáb"];

  cont.innerHTML = diasSemana.map(d => {
    const nombreDia = nombres[d.getDay()];
    const fechaStr = d.toISOString().substring(0, 10);

    return `
      <div class="day" onclick="abrirReservaParaFecha('${fechaStr}')">
        <div class="date">${nombreDia} ${d.getDate()}</div>
      </div>
    `;
  }).join("");
}

function abrirReservaParaFecha(fechaISO) {
  if (USER_ROLE === "Estudiante") {
    alert("Como estudiante solo puedes visualizar el calendario.");
    return;
  }
  openModal();
  const inputFecha = document.getElementById("fFecha");
  if (inputFecha) inputFecha.value = fechaISO;
}

// ===============================
// PRÓXIMAS RESERVAS (COLUMNA DERECHA)
// ===============================

function renderUpcomingList() {
  const cont = document.getElementById("upcomingList");
  if (!cont) return;

  if (!RESERVAS_PROX.length) {
    cont.innerHTML = `<div style="font-size:13px;color:var(--muted)">No tienes reservas próximas</div>`;
    return;
  }

  cont.innerHTML = RESERVAS_PROX.map(r => `
    <div class="upcoming-item">
      <strong>${r.espacio_nombre}</strong>
      <div class="meta">
        ${r.fecha_reserva} · ${r.hora_inicio} - ${r.hora_fin}
      </div>

      ${USER_ROLE === "Administrador" ? `
        <button 
          class="btn btn-small btn-danger" 
          style="margin-top:6px"
          onclick="deleteReserva(${r.id_reserva})">
          Eliminar reserva
        </button>
      ` : ""}
    </div>
  `).join("");
}

function openGlobalReservasModal() {
  document.getElementById("modalReservasGlobal").classList.add("show");
  cargarTodasLasReservas();
}

function closeGlobalReservasModal() {
  document.getElementById("modalReservasGlobal").classList.remove("show");
}

async function cargarTodasLasReservas() {
  const cont = document.getElementById("listaReservasGlobal");
  cont.innerHTML = "<p style='color:var(--muted)'>Cargando...</p>";

  try {
    const resp = await fetch("/api/admin/reservas/all");
    const data = await resp.json();

    if (!data.length) {
      cont.innerHTML = "<p style='color:var(--muted)'>No hay reservas registradas</p>";
      return;
    }

    cont.innerHTML = data.map(r => `
      <div class="reserva-item" style="padding:10px;border-bottom:1px solid #234">
        <strong>${r.espacio_nombre}</strong> — ${r.usuario}
        <br>
        ${r.fecha_reserva} | ${r.hora_inicio} - ${r.hora_fin}
        <br>
        <button class="btn btn-danger btn-small" 
                onclick="deleteReserva(${r.id_reserva})"
                style="margin-top:5px">
          Eliminar
        </button>
      </div>
    `).join("");

  } catch (err) {
    cont.innerHTML = "<p style='color:#e66'>Error cargando reservas</p>";
  }
}

// ===============================
// MODAL DE RESERVA
// ===============================

function wireModal() {
  const form = document.getElementById("formReserva");
  if (!form) return;

  form.addEventListener("submit", async e => {
    e.preventDefault();

    if (USER_ROLE === "Estudiante") {
      alert("Como estudiante no puedes crear reservas.");
      return;
    }

    const espacioId = document.getElementById("fEspacio").value;
    const fecha = document.getElementById("fFecha").value;
    const horaInicio = document.getElementById("fHoraInicio").value;
    const horaFin = document.getElementById("fHoraFin").value;

    if (!espacioId || !fecha || !horaInicio || !horaFin) {
      alert("Por favor completa todos los campos.");
      return;
    }

    // Validación de horario 7:00–22:00
    if (horaInicio < "07:00" || horaFin > "22:00" || horaFin <= horaInicio) {
      alert("Las reservas deben ser entre las 7:00 a.m. y las 10:00 p.m., y la hora de fin debe ser mayor que la de inicio.");
      return;
    }

    try {
      const resp = await fetch("/api/reservas", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          id_espacio: parseInt(espacioId, 10),
          fecha_reserva: fecha,
          hora_inicio: horaInicio,
          hora_fin: horaFin
        })
      });

      const data = await resp.json();

      if (data.ok) {
        alert("Reserva creada correctamente.");
        closeModal();
        cargarReservasProximas();
        cargarDashboard();
      } else {
        alert(data.error || data.msg || "No se pudo crear la reserva.");
      }
    } catch (err) {
      console.error(err);
      alert("Error de conexión con el servidor.");
    }
  });
}

async function deleteReserva(id_reserva) {
  if (!confirm("¿Seguro que deseas eliminar esta reserva?")) return;

  try {
    const resp = await fetch(`/api/reservas/${id_reserva}`, {
      method: "DELETE"
    });

    const data = await resp.json();

    if (data.ok) {
      alert("Reserva eliminada correctamente");
      // Refrescamos datos
      cargarReservasProximas();
      cargarDashboard();
      cargarEspacios();
    } else {
      alert(data.error || "No se pudo eliminar la reserva");
    }
  } catch (err) {
    console.error(err);
    alert("Error de conexión con el servidor");
  }
}

// Exponerla para que HTML pueda llamarla
window.deleteReserva = deleteReserva;


function handleRoomClick(espacioId) {
  if (USER_ROLE === "Estudiante") {
    alert("Como estudiante solo puedes visualizar la disponibilidad.");
    return;
  }
  openModal(espacioId);
}

function openModal(espacioId = null) {
  const modal = document.getElementById("modalReserva");
  if (!modal) return;

  modal.classList.add("show");

  const sel = document.getElementById("fEspacio");
  if (sel) {
    renderEspaciosSelect();
    if (espacioId) sel.value = String(espacioId);
  }

  const inputFecha = document.getElementById("fFecha");
  if (inputFecha && !inputFecha.value) {
    const hoy = new Date().toISOString().substring(0, 10);
    inputFecha.value = hoy;
  }
}

function closeModal() {
  const modal = document.getElementById("modalReserva");
  if (!modal) return;
  modal.classList.remove("show");
}

// Botón "+ Nueva" en la columna derecha
function openModalNuevoEspacio() {
  if (USER_ROLE === "Estudiante") {
    alert("Como estudiante no puedes crear reservas.");
    return;
  }
  openModal();
}

// ===============================
// EXPORTAR REPORTE (BOTÓN)
// ===============================

function exportarReporte() {
    window.open("/api/reportes/historial", "_blank");
}




// ===============================
// LISTENER FORM MANTENIMIENTO
// ===============================

const maintForm = document.getElementById("formMantenimiento");

if (maintForm) {
  maintForm.addEventListener("submit", async (e) => {
    e.preventDefault();

    const fi = document.getElementById("mFechaInicio").value;
    const ff = document.getElementById("mFechaFin").value;
    const desc = document.getElementById("mDescripcion").value;

    if (!fi || !ff) {
      alert("Debes seleccionar fecha de inicio y fecha de fin.");
      return;
    }

    const payload = {
      id_espacio: document.getElementById("mEspacioId").value,
      fecha_inicio: fi,
      fecha_fin: ff,
      descripcion: desc,
    };

    const resp = await fetch("/api/mantenimientos/crear", {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
      },
      body: JSON.stringify(payload),
    });

    const data = await resp.json();

    if (data.ok) {
      alert("Mantenimiento asignado correctamente");
      closeMaintenanceModal();
      cargarEspacios(); // refrescar lista
    } else {
      alert("Error: " + data.error);
    }
  });
}


// Exponer funciones que se usan desde HTML
window.openModal = openModal;
window.closeModal = closeModal;
window.openModalNuevoEspacio = openModalNuevoEspacio;
window.exportarReporte = exportarReporte;
window.abrirReservaParaFecha = abrirReservaParaFecha;
window.seleccionarBloque = seleccionarBloque;
window.openMaintenanceModal = openMaintenanceModal;
window.closeMaintenanceModal = closeMaintenanceModal;
window.handleRoomClick = handleRoomClick;
window.openGlobalReservasModal = openGlobalReservasModal;
window.closeGlobalReservasModal = closeGlobalReservasModal;
window.deleteReserva = deleteReserva;
