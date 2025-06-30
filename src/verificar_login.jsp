<%@ page import="java.sql.*, conexion.Base" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String usuario = request.getParameter("usuario");
    String contrasenia = request.getParameter("contrasenia");

    Base bd = new Base();
    bd.conectar();
    Connection con = bd.getConn();

    if (con != null) {
        try {
            String sql = "SELECT * FROM usuarios WHERE usuario = ? AND contrasena_hash = ?";
            PreparedStatement ps = con.prepareStatement(sql);
            ps.setString(1, usuario);
            ps.setString(2, contrasenia);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
            int id = rs.getInt("id");
            String nombreUsuario = rs.getString("usuario");

            // Guardar datos en sesión
            session.setAttribute("id", id);
            session.setAttribute("usuario", nombreUsuario);

            // Redirigir a perfil.jsp
            response.sendRedirect("perfil.jsp");
            } else {
                %>
                <div style="color: red; text-align: center; margin-top: 40px; font-size: 18px;">
                    ❌ Usuario o contraseña incorrectos.
                </div>
                <div style="text-align: center; margin-top: 10px;">
                    <a href="login.html" style="text-decoration: none; font-weight: bold;">Volver a intentar</a>
                </div>
    <%
            }
            rs.close();
            ps.close();
            con.close();
        } catch (Exception e) {
    %>
            <div style="color: red; text-align: center; margin-top: 40px;">
                 Error en la base de datos: <%= e.getMessage() %>
            </div>
    <%
        }
    } else {
    %>
        <div style="color: red; text-align: center; margin-top: 40px;">
             No se pudo conectar a la base de datos.
        </div>
    <%
    }
    %>
