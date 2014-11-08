class Yank
  act_as_a_dsl # active la déclaration de la dsl

  name :yank # définit le nom de la dsl, utilisé pour les params surtout
  method :acts_as_yankables # définit le nom de la méthode
  domain ActiveRecord::Base # définit la zone d'action de la dsl

  # définit des méthodes directement dans la classe du domaine
  # ce qui permet d'ajouter du comportement dans le domaine sans avoir appelé la méthode de la dsl
  before do
    def yanked?
      false
    end
  end

  # définit si je peux exécuter ou non la dsl
  allowed? do
    table_exists? # && column_names.include?("yank")
  end

  # définit le comportement en si le 'allowed?' réponds 'false'
  # il y a un "raise DslStandardError" par défaut, si rien n'est renseigné
  restricted do
    raise DatabaseSchemaError.new(self, method_name: 'bonjour')
  end

  # définit la structure des arguments que je peux utiliser pour la dsl
  params ->(y_arg, *y_args){}

  # définit les méthodes de classes qui seront ajoutés lors de l'utilisation de la dsl
  methods :class do


    yank.params.y_args # permet d'accéder aux arguments passés lors de l'appel de la dsl. c'est une Struct

    yank.extract_local_variables # extrait les arguments passés lors de l'appel de la dsl en variables locales
    y_args


    scope :yanked, ->{ all }

    def yanked?
      true
    end
  end

  # définit les méthodes d'instance qui seront ajoutés lors de l'utilisation de la dsl
  methods :instance do
    def yank
      "yank"
    end
  end

  # définit les méthodes de decorator qui seront ajoutés lors de l'utilisation de la dsl
  # uniquement si la classe "hôte" réponds à "decorator_klass" (c'est la cas si on utilise RKit::Decorator ^^)
  methods :decorator do
    def yank
      "yyyyyyyyy"
    end
  end
end

=begin
# utilisation
class Article < ActiveRecord::Base
  try_to_acts_as_yankables :y_arg # ne va pas trigger 'restricted' si le 'allowed?' réponds 'false'
  acts_as_yankables :y_arg # trigger le 'restricted'
end

class Commentaire < ActiveRecord::Base
end
-> Commentaire.new.yanked? #=> false


# in main
Article.can_acts_as_yankables?
Article.acts_as_yankables?
Yank.acts_as_yankables #=> [Article]

DSLS #=> {yank: [Article]}
=end
