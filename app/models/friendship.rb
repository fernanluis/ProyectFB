class Friendship < ApplicationRecord
  # rails generate model Friendship sent_to:references sent_by:references

  # Los enlaces asociativos belong_to crean asociaciones entre Friendship y Users.
  # Sent_to y sent_by vinculándolo a las columnas 'sent_to_id' y 'sent_by_id' como claves externas.
  # class_name: '..' es el nombre de la tabla o el modelo al que está vinculada ésta asociación.
  belongs_to :sent_to, class_name: 'User', foreign_key: 'sent_to_id' # se declaran asociaciones bidireccionales.
  belongs_to :sent_by, class_name: 'User', foreign_key: 'sent_by_id' # se declaran asociaciones bidireccionales.
  scope :friends, -> { where('status =?', true) }
  scope :not_friends, -> { where('status =?', false) }
end

# Los ámbitos creados simplemente proporcionan todos los registros en la tabla de amistad
# donde la columna de estado es igual a verdadero (para el ámbito de amigos) o falso
# (ámbito de no amigos).

# Los enlaces asociativos 'belong_to' crean dos asociaciones entre Amistades y Usuarios.
# Sent_to y sent_by vinculan a las columnas 'sent_to_id' y 'sent_by_id' como claves externas.
