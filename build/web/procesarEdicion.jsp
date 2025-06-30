<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="conexion.Base" %>
<%@ page session="true" %>
<%
    request.setCharacterEncoding("UTF-8");

    Integer id = (Integer) session.getAttribute("id");
    if (id == null) {
        response.sendRedirect("login.html");
        return;
    }

    String nombre = request.getParameter("nombre");
    String apellidos = request.getParameter("apellidos");
    String fechaNacimiento = request.getParameter("fecha_nacimiento");
    String sexo = request.getParameter("sexo");
    String usuario = request.getParameter("usuario");
    String nivel = request.getParameter("nivel");
    String genero = request.getParameter("genero_favorito");
    String[] instrumentosArray = request.getParameterValues("instrumentos");

    Base bd = new Base();
    bd.conectar();
    Connection con = bd.getConn();

    boolean actualizado = false;

    if (con != null) {
        try {
            // Actualizar usuario
            PreparedStatement ps = con.prepareStatement(
                "UPDATE usuarios SET nombre=?, apellidos=?, fecha_nacimiento=?, sexo=?, usuario=?, nivel=?, genero_favorito=? WHERE id=?");
            ps.setString(1, nombre);
            ps.setString(2, apellidos);
            ps.setString(3, fechaNacimiento);
            ps.setString(4, sexo);
            ps.setString(5, usuario);
            ps.setString(6, nivel);
            ps.setString(7, genero);
            ps.setInt(8, id);

            int filas = ps.executeUpdate();
            ps.close();

            // Actualizar instrumentos (eliminar y volver a insertar)
            PreparedStatement psDelete = con.prepareStatement("DELETE FROM usuario_instrumento WHERE id_usuario = ?");
            psDelete.setInt(1, id);
            psDelete.executeUpdate();
            psDelete.close();

            if (instrumentosArray != null) {
                for (String instrumento : instrumentosArray) {
                    PreparedStatement psInst = con.prepareStatement("SELECT id FROM instrumentos WHERE nombre = ?");
                    psInst.setString(1, instrumento);
                    ResultSet rsInst = psInst.executeQuery();

                    if (rsInst.next()) {
                        int idInstrumento = rsInst.getInt("id");
                        PreparedStatement psRel = con.prepareStatement(
                            "INSERT INTO usuario_instrumento (id_usuario, id_instrumento) VALUES (?, ?)");
                        psRel.setInt(1, id);
                        psRel.setInt(2, idInstrumento);
                        psRel.executeUpdate();
                        psRel.close();
                    }

                    rsInst.close();
                    psInst.close();
                }
            }

            con.close();
            actualizado = true;
        } catch (Exception e) {
            actualizado = false;
        }
    }
%>

<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Actualizar Perfil</title>
    <link rel="stylesheet" href="styles/perfil.css">
    <style>
        .mensaje {
            text-align: center;
            padding: 40px;
            font-size: 20px;
            margin-top: 50px;
        }
        .exito {
            color: #2e7d32;
        }
        .error {
            color: #c62828;
        }
    </style>
</head>
<body>
    <div class="mensaje <%= actualizado ? "exito" : "error" %>">
        <%
            if (actualizado) {
        %>
            Perfil Actualizado<br><br>
            <a href="perfil.jsp" class="boton-navegacion">Volver al perfil</a>
        <%
            } else {
        %>
            Error en la actualizacion, intentelo nuevamente
            <a href="perfil.jsp" class="boton-navegacion">Volver al perfil</a>
        <%
            }
        %>
    </div>
</body>
</html>