# README

Implementación de Ruby on Rails

Un similar de Facebook, según el Proyecto Odin: https://www.theodinproject.com/courses/ruby-on-rails/lessons/final-project

En ésta réplica de Facebook como proyecto de Ruby on Rails permite la creación de usuarios, realizar publicaciones, comentar las publicaciones, enviar solicitudes de amistad, responder las solicitudes de amistad, generar likes a las publicaciones y comentarios. Permite recibir notificaciones de cada una de las interaciones entre los diferentes recursos, como por ejemplo, recibir notificaciones de likes, post, comments, solicitudes de amistad.

Facebook contiene las siguientes tablas de base de datos: usuarios, solicitudes de amistad, publicaciones, comentarios, "me gusta", y notificaciones.

Base de datos: PostgreSQL

Algunas de las gemas agregadas: 'rubocop', 'devise', 'carrierwave', '~> 2.0', 'mini_magick', 'bootstrap', 'hirb'.

Permite eliminar los registros sin errores de asociación SQL. Por ejemplo eliminar los registros de "me gusta" (likes). Podemos eliminar comentarios o publicaciones (dependent: :destroy es el parámetro). Además de considerar la opción de permitir valores nulos para las llaves foráneas de post_id y comment_id se edita db/migrate/..like.rb creando la asociación entre los likes y los usuarios (users), like y publicaiones (posts), así como también like y comentarios (comments).
Es decir, permitir además que un like pueda pertenecer a un user, y un post o un comments. Además de agregar el inverso.

Solicitud de amistad (friendship), generado a partir de "rails generate model Friendship sent_to:references sent_by:references". Antes de editarlo, las llaves foráneas se establecen en true, pero en su lugar son configuradas con foreign_key:{to_table: :users} vinculandoló a la tabla de users.

Una vez realizadas las migraciones necesarias, se agregan parámetros adicionales al modelo de solicitud de amistad creado, así como dos ámbitos. Los ámbitos creados simplemente proporcionan todos los registros en la tabla de amistad donde la columna de estado es igual a true (para el ámbito de amigos(friends)) o false (para el ámbito de NO amigos).

Asociaciones inversas creadas para vincular a las asociaciones sent_to y sent_by realizadas en el modelo de friendship (app/models/friendship.rb) y (app/models/user.rb)

Notificaciones (notification), lugar donde permitimos, a traves de los scope, destacar las notificaciones por tipo, ejemplo; "like", comments o solicitudes de amistad.
No se ha generado un controlador Notification, sin embargo, los métodos principales que se utilizan para crear notificaciones serán creados en AplicationHelper.
Dado que una notificación solo se creará como resultado de la llamada a otra función de método y no tiene una vista real. En lugar de crear un controlador, simplemente se crea como un método auxiliar.

Para las vistas (Views):

Bootstrap: https://getbootstrap.com/
GoogleFonts: https://fonts.google.com/
FontAwesome: https://fontawesome.com/

Mostrar cómo usar las funciones auxiliares y los métodos de controlador para lograr los objetivos.

Vistas de diseño / Layout Views: vistas que se pueden ver en cada página, por lo tanto, es el lugar para las notificaciones flash y la barra de navegación.

Creating Posts
