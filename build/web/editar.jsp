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

        // Obtener instrumentos del usuario
        PreparedStatement psi = con.prepareStatement("SELECT i.nombre FROM usuario_instrumento ui JOIN instrumentos i ON ui.id_instrumento = i.id WHERE ui.id_usuario = ?");
        psi.setInt(1, id);
        ResultSet rsi = psi.executeQuery();
        while (rsi.next()) {
            instrumentos.add(rsi.getString("nombre"));
        }
        rsi.close();
        psi.close();
        con.close();
    }

    // Lista completa de instrumentos
    String[] todosInstrumentos = {"piano", "guitarra", "violin", "bateria", "flauta", "ukelele", "bajo", "voz", "saxofon", "trompeta", "otros"};
%>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <title>Editar Perfil - Eufolkia</title>
    <link rel="stylesheet" href="styles/registro.css">
    <script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
</head>
<body>

<nav class="barra-navegacion">
    <div class="contenedor-barra">
        <div class="contenedor-logo">
            <img src="img/Logo_eulfolkia.png" alt="Eufolkia Logo" class="logo" />
            <span class="texto-logo">EUFOLKIA</span>
        </div>
    </div>
</nav>

<main class="contenedor-registro">
    <div class="contenedor">
        <div class="tarjeta-registro">
            <form id="formulario-edicion" action="procesarEdicion.jsp" method="post">
                <div class="rejilla-formulario">

                    <div class="texto-bienvenida">
                        <h3>Edita tu perfil</h3>
                        <p>Actualiza tu información personal para mantener tu cuenta al día.</p>
                    </div>

                    <div class="grupo-formulario">
                        <label for="nombre">Nombre(s)</label>
                        <input type="text" id="nombre" name="nombre" value="<%= nombre %>" required>
                    </div>

                    <div class="grupo-formulario">
                        <label for="apellidos">Apellido(s)</label>
                        <input type="text" id="apellidos" name="apellidos" value="<%= apellidos %>" required>
                    </div>

                    <div class="grupo-formulario">
                        <label for="fecha_nacimiento">Fecha de Nacimiento</label>
                        <input type="date" id="fecha_nacimiento" name="fecha_nacimiento" value="<%= fechaNacimiento %>" required>
                    </div>

                    <div class="grupo-formulario">
                        <label for="sexo">Sexo</label>
                        <select id="sexo" name="sexo" required>
                            <option value="" disabled>Sexo</option>
                            <%
                                String[] opcionesSexo = {"masculino", "femenino", "otro", "no_especificar"};
                                for (String op : opcionesSexo) {
                            %>
                            <option value="<%= op %>" <%= op.equals(sexo) ? "selected" : "" %>><%= op.substring(0,1).toUpperCase() + op.substring(1) %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="grupo-formulario">
                        <label for="usuario">Usuario</label>
                        <input type="text" id="usuario" name="usuario" value="<%= usuario %>" required>
                    </div>

                    <div class="grupo-formulario">
                        <label>Instrumento(s) que practicas</label>
                        <div class="rejilla-instrumentos">
                            <%
                                for (String inst : todosInstrumentos) {
                                    boolean seleccionado = instrumentos.contains(inst);
                            %>
                            <div class="opcion-radio">
                                <input type="checkbox" id="<%= inst %>" name="instrumentos" value="<%= inst %>" <%= seleccionado ? "checked" : "" %>>
                                <label for="<%= inst %>"><%= inst.substring(0,1).toUpperCase() + inst.substring(1) %></label>
                            </div>
                            <% } %>
                        </div>
                    </div>

                    <div class="grupo-formulario">
                        <label for="nivel">Nivel</label>
                        <select id="nivel" name="nivel" required>
                            <%
                                String[] niveles = {"principiante", "intermedio", "avanzado", "profesional"};
                                for (String n : niveles) {
                            %>
                            <option value="<%= n %>" <%= n.equals(nivel) ? "selected" : "" %>><%= n.substring(0,1).toUpperCase() + n.substring(1) %></option>
                            <% } %>
                        </select>
                    </div>

                    <div class="grupo-formulario">
                        <label for="genero_favorito">Género Favorito</label>
                        <select id="genero_favorito" name="genero_favorito" required>
                            <%
                                String[] generos = {"rock", "pop", "jazz", "clasica", "folk", "electronica", "metal", "indie", "otro"};
                                for (String g : generos) {
                            %>
                            <option value="<%= g %>" <%= g.equals(genero) ? "selected" : "" %>><%= g.substring(0,1).toUpperCase() + g.substring(1) %></option>
                            <% } %>
                        </select>
                    </div>
                </div>

                <div class="botones-navegacion">
                    <button type="submit" class="btn btn-listo"><i class="fas fa-save"></i> Guardar cambios</button>
                </div>
            </form>
        </div>
    </div>
</main>

<script src="js/registro.js"></script>
</body>
</html>