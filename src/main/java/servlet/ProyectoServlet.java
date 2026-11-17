package servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import entidades.Proyecto;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class ProyectoServlet
 */
public class ProyectoServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private List<Proyecto> listaProyectos = new ArrayList<Proyecto>();

	/**
	 * Default constructor.
	 */
	public ProyectoServlet() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		response.getWriter().append("Served at: ").append(request.getContextPath());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");

		// Acción del botón presionado (si no viene ninguna, se registra)
		String accion = request.getParameter("accion");
		if (accion == null) {
			accion = "registrar";
		}

		// Posición del proyecto en la lista (para editar, actualizar y eliminar)
		int indice = -1;
		String id = request.getParameter("id");
		if (id != null && !id.isEmpty()) {
			try {
				indice = Integer.parseInt(id);
			} catch (NumberFormatException e) {
				indice = -1;
			}
		}
		boolean indiceValido = indice >= 0 && indice < listaProyectos.size();

		if (accion.equals("editar") && indiceValido) {
			// Carga el proyecto en el formulario
			request.setAttribute("proyectoEditar", listaProyectos.get(indice));
			request.setAttribute("idEditar", indice);

		} else if (accion.equals("eliminar") && indiceValido) {
			listaProyectos.remove(indice);
			request.setAttribute("mensaje", "Proyecto eliminado correctamente.");

		} else if (accion.equals("registrar") || accion.equals("actualizar")) {

			String nombre = request.getParameter("nombre").trim();
			String descripcion = request.getParameter("descripcion").trim();
			String fechaInicio = request.getParameter("fechaInicio");
			String fechaFin = request.getParameter("fechaFin");
			String asesor = request.getParameter("asesor").trim();
			String presupuesto = request.getParameter("presupuesto").trim();

			List<String> errores = new ArrayList<String>();

			if (accion.equals("actualizar") && !indiceValido) {
				errores.add("Seleccione un proyecto de la tabla para actualizar.");
			}
			if (nombre.length() < 4 || nombre.length() > 60) {
				errores.add("El nombre debe tener de 4 a 60 caracteres.");
			}
			if (fechaInicio.isEmpty()) {
				errores.add("La fecha de inicio es requerida.");
			}
			if (fechaFin.isEmpty()) {
				errores.add("La fecha de culminación es requerida.");
			}
			if (asesor.isEmpty()) {
				errores.add("El asesor técnico es requerido.");
			}
			if (presupuesto.isEmpty()) {
				errores.add("El presupuesto es requerido.");
			}

			if (errores.isEmpty()) {
				Proyecto proyecto = new Proyecto(nombre, descripcion, fechaInicio, fechaFin, asesor, presupuesto);
				if (accion.equals("actualizar")) {
					listaProyectos.set(indice, proyecto);
					request.setAttribute("mensaje", "Proyecto actualizado correctamente.");
				} else {
					listaProyectos.add(proyecto);
					request.setAttribute("mensaje", "Proyecto registrado correctamente.");
				}
			} else {
				request.setAttribute("errores", errores);
				if (accion.equals("actualizar") && indiceValido) {
					request.setAttribute("idEditar", indice);
				}
			}
		}
		// Si la acción es "listar" no se hace nada más: solo se muestra la tabla

		request.setAttribute("proyectos", listaProyectos);
		request.getRequestDispatcher("registro.jsp").forward(request, response);

	}

}