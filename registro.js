document.addEventListener("DOMContentLoaded", () => {
  const form = document.getElementById("formulario-registro");

  form.addEventListener("submit", async (e) => {
    // Deja que JSP reciba los datos
    const formData = new FormData(form);

    const datos = {
      nombre: formData.get("nombre"),
      apellidos: formData.get("apellidos"),
      fecha_nacimiento: formData.get("fecha_nacimiento"),
      sexo: formData.get("sexo"),
      usuario: formData.get("usuario"),
      contrasena_hash: formData.get("contrasena_hash"),
      nivel: formData.get("nivel"),
      genero_favorito: formData.get("genero_favorito"),
      instrumentos: Array.from(
        document.querySelectorAll('input[name="instrumentos"]:checked')
      ).map((el) => el.value),
    };

    try {
      const res = await fetch("https://csfjdlxrckvmphyjueny.supabase.co/rest/v1/usuarios", {
        method: "POST",
        headers: {
          apikey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
          Authorization: "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
          "Content-Type": "application/json",
          Prefer: "return=minimal" // O "representation" si quieres que te devuelva los datos
        },
        body: JSON.stringify(datos),
      });

      if (!res.ok) {
        console.error("🚨 Error Supabase:", await res.text());
      } else {
        console.log("✅ Guardado también en Supabase");
      }
    } catch (err) {
      console.error("❌ Error al conectar con Supabase:", err);
    }
  });
});