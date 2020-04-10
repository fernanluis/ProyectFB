# README

Implementación de Ruby on Rails

Un similar de Facebook, según el Proyecto Odin: https://www.theodinproject.com/courses/ruby-on-rails/lessons/final-project

En ésta réplica de Facebook como proyecto de Ruby on Rails permite la creación de usuarios con nombre y apellido, además de un mail y una imagen de perfil, realizar publicaciones, comentar las publicaciones, enviar solicitudes de amistad, responder las solicitudes de amistad, generar likes a las publicaciones y comentarios. Permite recibir notificaciones de cada una de las interaciones entre los diferentes recursos, como por ejemplo, recibir notificaciones de likes, post, comments, solicitudes de amistad.

Facebook contiene las siguientes tablas de base de datos: usuarios, solicitudes de amistad, publicaciones, comentarios, "me gusta", y notificaciones.

Base de datos: PostgreSQL

Algunas de las gemas utilizadas: 'rubocop', 'devise', 'carrierwave', '~> 2.0', 'mini_magick', 'bootstrap', 'hirb'.

Permiso de parámetros adicionales con Devise: para manejar procesos de registro e inicio de sesión, y permitir la recuperación de los parámetros de columnas fname, lname e image de los futuros formularios.
app/controllers/application.rb

Adding Image Uploads: las cargas de imágenes con gem 'carrierwave' y 'mini_magick'
Algunas modificaciones en app/uploaders/image_uploader.rb; línea 5 incorporada (cambia el tamaño de cualquier imagen cargada que tenga un ancho o alto mayor de 400 píxeles a 400 píxeles de ancho y 400 píxeles de alto como opción dada.) y líneas 38 y 40 descomentadas

Agregado, mount_uploader (cargador de montaje) al usuario, línea 2 app/models/user.rb, con requisitos de validación para el modelo usuario y devolución de error si la imagen cargada es mayor a 1 megabyte.

Cuenta con un campo de imagen a la página de registro y algo de JavaScript que identifica un error de alerta cuando el archivo cargado tiene un tamaño superior a 1 MB.

Permite eliminar los registros sin errores de asociación SQL. Por ejemplo eliminar los registros de "me gusta" (likes). Podemos eliminar comentarios o publicaciones (dependent: :destroy es el parámetro). Además de considerar la opción de permitir valores nulos para las llaves foráneas de post_id y comment_id se edita db/migrate/..like.rb creando la asociación entre los likes y los usuarios (users), like y publicaiones (posts), así como también like y comentarios (comments).
Es decir, permitir además que un like pueda pertenecer a un user, y un post o un comments. Además de agregar el inverso.

Solicitud de amistad (friendship), generado a partir de "rails generate model Friendship sent_to:references sent_by:references". Antes de editarlo, las llaves foráneas se establecen en true, pero en su lugar son configuradas con foreign_key:{to_table: :users} vinculandoló a la tabla de users.

Una vez realizadas las migraciones necesarias, se agregan parámetros adicionales al modelo de solicitud de amistad creado, así como dos ámbitos. Los ámbitos creados simplemente proporcionan todos los registros en la tabla de amistad donde la columna de estado es igual a true (para el ámbito de amigos(friends)) o false (para el ámbito de NO amigos).

Asociaciones inversas creadas para vincular a las asociaciones sent_to y sent_by realizadas en el modelo de friendship (app/models/friendship.rb) y (app/models/user.rb)

Notificaciones (notification), lugar donde permitimos, a traves de los scope, destacar las notificaciones por tipo, ejemplo; "like", comments o solicitudes de amistad.
No se ha generado un controlador Notification, sin embargo, los métodos principales que se utilizan para crear notificaciones serán creados en AplicationHelper.
Dado que una notificación solo se creará como resultado de la llamada a otra función de método y no tiene una vista real. En lugar de crear un controlador, simplemente se crea como un método auxiliar.

Para las vistas (Views) se usaron:

Bootstrap: https://getbootstrap.com/
GoogleFonts: https://fonts.google.com/
FontAwesome: https://fontawesome.com/

Mostrar cómo usar las funciones auxiliares y los métodos de controlador para lograr los objetivos.

Vistas de diseño / Layout Views: vistas que se pueden ver en cada página, por lo tanto, es el lugar para las notificaciones flash y la barra de navegación.

Vista modal de la decisión de amistad
