<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="conexion.Base" %>
<%@ page session="true" %>
<%
    Integer id = (Integer) session.getAttribute("id");
    if (id == null) {
        response.sendRedirect("login.html");
        return;
    }

    String nombre = "", apellidos = "", fechaNacimiento = "", sexo = "", nivel = "", genero = "", usuario = "";
    List<String> instrumentos = new ArrayList<>();

    Base bd = new Base();
    bd.conectar();
    Connection con = bd.getConn();

    if (con != null) {
        PreparedStatement ps = con.prepareStatement("SELECT * FROM usuarios WHERE id = ?");
        ps.setInt(1, id);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            nombre = rs.getString("nombre");
            apellidos = rs.getString("apellidos");
            fechaNacimiento = rs.getString("fecha_nacimiento");
            sexo = rs.getString("sexo");
            usuario = rs.getString("usuario");
            nivel = rs.getString("nivel");
            genero = rs.getString("genero_favorito");
        }
        rs.close();
        ps.close();

        PreparedStatement psi = con.prepareStatement(
            "SELECT i.nombre FROM usuario_instrumento ui JOIN instrumentos i ON ui.id_instrumento = i.id WHERE ui.id_usuario = ?");
        psi.setInt(1, id);
        ResultSet rsi = psi.executeQuery();
        while (rsi.next()) {
            instrumentos.add(rsi.getString("nombre"));
        }
        rsi.close();
        psi.close();
        con.close();
    }
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Mi Perfil - Eufolkia</title>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
    <link rel="stylesheet" href="styles/perfil.css">
</head>
<body>
<header class="encabezado">
    <nav class="navegacion-principal">
        <div class="contenedor-navegacion">
            <div class="contenedor">
                <a href="inicio.html" class="boton-regresar" id="enlace-regresar">
                    <i class="fas fa-arrow-left"></i>
                </a>
            </div>
            <div class="logo-contenedor">
                <img src="img/Logo_eulfolkia.png" alt="Eufolkia Logo" class="logo">
                <span class="texto-logo">EUFOLKIA</span>
                <span class="texto-perfil">Mi perfil</span>
            </div>
        </div>
    </nav>
</header>

<div class="contenedor">
    <div class="contenido-principal">
        <div id="perfil" class="contenido-perfil">
            <br><br>
            <div class="seccion-perfil1">
                <div class="informacion-perfil">

                    <div class="grupo-formulario">
                        <label>Nombre de usuario:</label>
                        <p><%= usuario %></p>
                    </div>
                    <div class="grupo-formulario">
                        <label>Nombre completo:</label>
                        <p><%= nombre + " " + apellidos %></p>
                    </div>
                    <div class="grupo-formulario">
                        <label>Fecha de nacimiento:</label>
                        <p><%= fechaNacimiento %></p>
                    </div>
                    <div class="grupo-formulario">
                        <label>Sexo:</label>
                        <p><%= sexo %></p>
                    </div>
                    <div class="grupo-formulario">
                        <label>Nivel:</label>
                        <p><%= nivel %></p>
                    </div>
                    <div class="grupo-formulario">
                        <label>Género favorito:</label>
                        <p><%= genero %></p>
                    </div>
                    <div class="grupo-formulario">
                        <label>Instrumentos:</label>
                        <ul>
                            <% for (String inst : instrumentos) { %>
                                <li><%= inst %></li>
                            <% } %>
                        </ul>
                    </div>

                </div>

                <div class="resumen">
                    <h3>Resumen de Actividad</h3>
                    <div style="margin: 20px 0;">
                        <div class="item-actividad"><div>Contenido subido:</div><div><strong>0</strong></div></div>
                        <div class="item-actividad"><div>Tutoriales creados:</div><div><strong>0</strong></div></div>
                        <div class="item-actividad"><div>Partituras compartidas:</div><div><strong>0</strong></div></div>
                        <div class="item-actividad"><div>Videos subidos:</div><div><strong>0</strong></div></div>
                    </div>
                </div>
            </div>
        </div>
            <div class="contenedor-botones-perfil">
            <a href="inicio.html" class="boton-navegacion">
            <i class="fas fa-home"></i> Inicio
            </a>
            <a href="index.html" class="boton-navegacion">
            <i class="fas fa-sign-out-alt"></i> Cerrar Sesión
            </a>
            <a href="editar.jsp" class="boton-navegacion">
            <i class="fas fa-user-edit"></i> Editar Perfil
            </a>
        </div>
    </div>
</div>
                        
<script src="js/perfil.js"></script>
</body>
</html>