<%@ page import="java.sql.*" %>
<%@ page import="conexion.Base" %>
<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Alta</title>
    <style>
        body.cuerpo {
            background: #5c5cf7;
            font-family: Arial, sans-serif;
            color: #333;
        }
        .btn-regresar {
            padding: 12px 25px;
            border: none;
            border-radius: 30px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            background-color: #e6c200;
            color: #333 !important;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .btn-regresar:hover {
            background-color: #c9ad00;
        }

        .mensaje {
            padding: 20px;
            border-radius: 5px;
            font-weight: bold;
            max-width: 500px;
            margin: 20px auto;
            text-align: center;
            color: white;
        }
        .exito {
            background-color: #4CAF50;
        }
        .error {
            background-color: #f44336;
        }
    </style>
</head>
<body class="cuerpo">

<%
    // Recibir datos del formulario
    String nombre = request.getParameter("nombre");
    String apellidos = request.getParameter("apellidos");
    String fechaNacimiento = request.getParameter("fecha_nacimiento");
    String sexo = request.getParameter("sexo");
    String usuario = request.getParameter("usuario");
    String contrasena = request.getParameter("contrasena_hash");
    String nivel = request.getParameter("nivel");
    String generoFavorito = request.getParameter("genero_favorito");
    String[] instrumentosArray = request.getParameterValues("instrumentos");

    Base bd = new Base();
    bd.conectar();
    Connection con = bd.getConn();

    if (con != null) {
        try {
            // Validar si el usuario ya existe
            PreparedStatement psCheck = con.prepareStatement("SELECT COUNT(*) FROM usuarios WHERE usuario = ?");
            psCheck.setString(1, usuario);
            ResultSet rsCheck = psCheck.executeQuery();
            rsCheck.next();
            int existe = rsCheck.getInt(1);
            rsCheck.close();
            psCheck.close();

            if (existe > 0) {
%>
                <div class="mensaje error">❌ El usuario ya existe, elige otro nombre.</div>
<%
            } else {
                // Insertar usuario
                String sql = "INSERT INTO usuarios (nombre, apellidos, fecha_nacimiento, sexo, usuario, contrasena_hash, nivel, genero_favorito) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
                PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
                ps.setString(1, nombre);
                ps.setString(2, apellidos);
                ps.setString(3, fechaNacimiento);
                ps.setString(4, sexo);
                ps.setString(5, usuario);
                ps.setString(6, contrasena);
                ps.setString(7, nivel);
                ps.setString(8, generoFavorito);

                int filas = ps.executeUpdate();
                int idUsuario = -1;

                if (filas > 0) {
                    ResultSet rs = ps.getGeneratedKeys();
                    if (rs.next()) {
                        idUsuario = rs.getInt(1);
                    }
                    rs.close();
                }
                ps.close();

                // Insertar instrumentos seleccionados
                if (idUsuario != -1 && instrumentosArray != null) {
                    for (String instrumento : instrumentosArray) {
                        // Buscar el id del instrumento por su nombre
                        PreparedStatement psInst = con.prepareStatement("SELECT id FROM instrumentos WHERE nombre = ?");
                        psInst.setString(1, instrumento);
                        ResultSet rsInst = psInst.executeQuery();

                        if (rsInst.next()) {
                            int idInstrumento = rsInst.getInt("id");
                            PreparedStatement psRel = con.prepareStatement("INSERT INTO usuario_instrumento (id_usuario, id_instrumento) VALUES (?, ?)");
                            psRel.setInt(1, idUsuario);
                            psRel.setInt(2, idInstrumento);
                            psRel.executeUpdate();
                            psRel.close();
                        }

                        rsInst.close();
                        psInst.close();
                    }
                }

%>
                <div class="mensaje exito">✅ Registro insertado correctamente.</div>
<%
            }

            con.close();
        } catch (Exception e) {
%>
            <div class="mensaje error">❌ Error en la base de datos: <%= e.getMessage() %></div>
<%
        }
    } else {
%>
        <div class="mensaje error">❌ No se pudo conectar a la base de datos.</div>
<%
    }
%>

<br><br>
<div style="text-align:center;">
    <a href="index.html" class="btn-regresar">Regresar</a>
</div>

</body>
</html>
