<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList, java.util.List, entidades.Proyecto" %>
<%!
    String nvl(String s) {
        return s == null ? "" : s;
    }
%>
<%
    List<Proyecto> proyectos = (List<Proyecto>) request.getAttribute("proyectos");
    if (proyectos == null) {
        proyectos = new ArrayList<Proyecto>();
    }
    List<String> errores = (List<String>) request.getAttribute("errores");
    String mensaje = (String) request.getAttribute("mensaje");

    Proyecto pe = (Proyecto) request.getAttribute("proyectoEditar");
    Integer idEditar = (Integer) request.getAttribute("idEditar");
    boolean editando = idEditar != null;

    // Valores que se muestran en el formulario
    String vNombre = "", vDescripcion = "", vInicio = "", vFin = "", vAsesor = "", vPresupuesto = "";
    if (pe != null) {
        vNombre = pe.getNombre();
        vDescripcion = pe.getDescripcion();
        vInicio = pe.getFechaInicio();
        vFin = pe.getFechaFin();
        vAsesor = pe.getAsesor();
        vPresupuesto = pe.getPresupuesto();
    } else if (errores != null) {
        vNombre = nvl(request.getParameter("nombre"));
        vDescripcion = nvl(request.getParameter("descripcion"));
        vInicio = nvl(request.getParameter("fechaInicio"));
        vFin = nvl(request.getParameter("fechaFin"));
        vAsesor = nvl(request.getParameter("asesor"));
        vPresupuesto = nvl(request.getParameter("presupuesto"));
    }
%>
<!DOCTYPE html>
<html lang="es" data-bs-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Proyectos de Inversión Pública</title>

    <!-- Bootstrap 6.0 (alpha) -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@6.0.0-alpha.1/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
</head>
<body>
    <div class="container mt-4">
        <div class="row">

            <!-- IZQUIERDA: formulario -->
            <div class="col-5">
                <h2 class="mb-3"><%= editando ? "Editar Proyecto" : "Registrar Proyecto" %></h2>

                <% if (mensaje != null) { %>
                    <div class="p-3 mb-3 rounded border bg-subtle-success"><%= mensaje %></div>
                <% } %>

                <% if (errores != null) { %>
                    <div class="p-3 mb-3 rounded border bg-subtle-danger">
                        <ul class="mb-0">
                            <% for (String e : errores) { %>
                                <li><%= e %></li>
                            <% } %>
                        </ul>
                    </div>
                <% } %>

                <form action="ProyectoServlet" method="post">
                    <!-- Posición del proyecto que se está editando -->
                    <input type="hidden" name="id" value="<%= editando ? String.valueOf(idEditar) : "" %>">

                    <div class="mb-3">
                        <label class="form-label">Nombre del Proyecto</label>
                        <input type="text" class="form-control" name="nombre"
                               required minlength="4" maxlength="60" value="<%= vNombre %>">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Descripción técnica del Proyecto (Opcional)</label>
                        <textarea class="form-control" name="descripcion" rows="4"><%= vDescripcion %></textarea>
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Fecha de inicio del Proyecto</label>
                        <input type="date" class="form-control" name="fechaInicio" required value="<%= vInicio %>">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Fecha de culminación del Proyecto</label>
                        <input type="date" class="form-control" name="fechaFin" required value="<%= vFin %>">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Asesor Técnico del Proyecto (Nombres y Apellidos)</label>
                        <input type="text" class="form-control" name="asesor" required value="<%= vAsesor %>">
                    </div>

                    <div class="mb-3">
                        <label class="form-label">Presupuesto Asignado</label>
                        <input type="number" class="form-control" name="presupuesto"
                               required min="0" step="0.01" value="<%= vPresupuesto %>">
                    </div>

                    <div class="d-flex gap-2">
                        <button type="submit" name="accion" value="registrar"
                                class="btn-solid theme-primary">Registrar</button>
                        <button type="submit" name="accion" value="actualizar"
                                class="btn-solid theme-info" <%= editando ? "" : "disabled" %>>Actualizar</button>
                        <button type="submit" name="accion" value="listar" formnovalidate
                                class="btn-solid theme-warning">Listar</button>
                        <button type="submit" name="accion" value="eliminar" formnovalidate
                                class="btn-solid theme-danger" <%= editando ? "" : "disabled" %>>Eliminar</button>
                    </div>
                </form>
            </div>

            <!-- DERECHA: tabla -->
            <div class="col-7">
                <h2 class="mb-3">Proyectos Disponibles</h2>

                <table class="table table-striped table-bordered">
                    <thead>
                        <tr>
                            <th>Id</th>
                            <th>Nombre del Proyecto</th>
                            <th>Inicio</th>
                            <th>Fin</th>
                            <th>Asesor Técnico</th>
                            <th>Presupuesto</th>
                            <th>Acciones</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% int n = 1;
                           for (Proyecto p : proyectos) { %>
                            <tr>
                                <td><%= n %></td>
                                <td><%= p.getNombre() %></td>
                                <td><%= p.getFechaInicio() %></td>
                                <td><%= p.getFechaFin() %></td>
                                <td><%= p.getAsesor() %></td>
                                <td>S/ <%= p.getPresupuesto() %></td>
                                <td>
                                    <div class="d-flex gap-1">
                                        <!-- Info: muestra u oculta la descripción (Toggler) -->
                                        <button type="button"
                                                class="btn-subtle theme-info btn-icon btn-sm"
                                                data-bs-toggle="toggler"
                                                data-bs-target="#detalle<%= n %>"
                                                aria-label="Ver descripción técnica">
                                            <i class="bi bi-info-circle-fill"></i>
                                        </button>

                                        <!-- Editar: carga el proyecto en el formulario -->
                                        <form action="ProyectoServlet" method="post" class="m-0">
                                            <input type="hidden" name="id" value="<%= n - 1 %>">
                                            <button type="submit" name="accion" value="editar"
                                                    class="btn-subtle theme-primary btn-icon btn-sm"
                                                    aria-label="Editar proyecto">
                                                <i class="bi bi-pencil-fill"></i>
                                            </button>
                                        </form>

                                        <!-- Eliminar: borra el proyecto de la fila -->
                                        <form action="ProyectoServlet" method="post" class="m-0"
                                              onsubmit="return confirm('¿Eliminar este proyecto?')">
                                            <input type="hidden" name="id" value="<%= n - 1 %>">
                                            <button type="submit" name="accion" value="eliminar"
                                                    class="btn-subtle theme-danger btn-icon btn-sm"
                                                    aria-label="Eliminar proyecto">
                                                <i class="bi bi-trash-fill"></i>
                                            </button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                            <tr id="detalle<%= n %>" data-bs-attribute="hidden" data-bs-value="true" hidden>
                                <td colspan="7">
                                    <strong>Descripción técnica:</strong>
                                    <%= p.getDescripcion().isEmpty() ? "Sin descripción" : p.getDescripcion() %>
                                </td>
                            </tr>
                        <%  n++;
                           } %>
                    </tbody>
                </table>
            </div>

        </div>
    </div>

    <!-- Bootstrap JS: necesario para el Toggler -->
    <script type="module" src="https://cdn.jsdelivr.net/npm/bootstrap@6.0.0-alpha.1/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>