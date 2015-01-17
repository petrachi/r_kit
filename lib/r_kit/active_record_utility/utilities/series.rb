class RKit::ActiveRecordUtility::Series

  # TODO: series must change to smthing bigger (maybe a service for itself)
  # I want the "serie" to have its own DB-Table
  # with tag, title, brief & custom-paginable
  # (the custom paginable, could use only the pagination decorator, or a new dsl that inherit from paginable)
  # and I want to be able to display the series's title+brief if needed
  # (for example, when the scope "first_of_series" is called)
  # TODO: maybe rename to "thread" ?

  act_as_a_dsl

  name :series_dsl
  method :acts_as_seriables
  domain ActiveRecord::Base

  allowed? do
    table_exists? &&
      column_names.include?("following_id") &&
      columns_hash["following_id"].type == :integer
  end

  restricted do
    raise DatabaseSchemaError.new(self, method_name: series_dsl.method)
  end



  methods :class do
    has_one :followed, class_name: name, foreign_key: "following_id"
    belongs_to :following, class_name: name

    # before_validation if: :following_id_changed? do
      # self.title ||= following.title if __class__.column_exists? "title"
      # self.series = following.series.name
    # end




    # TODO: after save, if series change, all obj in series change

    # TODO: we can add a conditionnal validation on 'inclusion_in' (like pool)

    # TODO: validates presence of serie also on the followed record

    # TODO: validates a record can only have one follower (or is it hadled by the "has_one" relation directly ?)

    # validates_presence_of :series, if: :following
    validates_uniqueness_of :following_id, if: :following

    # scope :series, ->(series){ series && where(series: series) }
    scope :firsts_of_series, ->{ where(following_id: nil) }

    # TODO: scope pour l'ordre dans une serie (pour le decorator pagination_tag)

    # @@_active_record_utilities_series = {}
  end


  methods :instance do
    def first_of_serie
      following ? following.send(__method__) : self
    end

    def series
      first_of_serie.nexts_of_serie if in_a_series?
    end

    def in_a_series?
      following || followed
    end

    def nexts_of_serie
      followed ? [self] + followed.send(__method__) : [self]
    end

    # def series
    #   series_struct if read_attribute(:series)
    #   # @@_active_record_utilities_series[read_attribute(:series)] ||= series_struct if read_attribute(:series)
    #   # TODO: if series changes, or new element added, series must be re-calculated
    #   # maybe pre-calc this in after save
    # end
    #
    # def series_struct
    #   OpenStruct.new.tap do |series_struct|
    #     series_struct.name = read_attribute :series
    #     series_struct.collection = __class__.series series_struct.name
    #     series_struct.size = series_struct.collection.count
    #   end
    # end

    def position_in_series
      following ? following.send(__method__) + 1 : 1
    end
  end


  methods :decorator do
    #after_initialize do
      # TODO: this can't stay this way, if "serie" is pre-calculated
      # & shared accros instances & kept in memory (class variable)

      # series.collection = series.collection.decorate if series
      # TODO: infinite loop, need a "unless" on the after_init, or smthng even more smart
      # ps: i'm not happy with this current decorate
    #end

    # depend on: :series do
    #   def series_url
    #     view.url_for [__class__, series: series.name]
    #   end
    #
    #   def link_to_series
    #     view.link_to series.name, series_url, class: :btn
    #   end
    # end


    if decorated_class.columns_hash["title"]
      depend on: :series, strict: false do

        # TODO: I don't get this "showcase thing", we can delete that and just look into the view for the params
        # Or in the collection, to see if the scope is applied (second solution is better)
        # TODO: to make a decision, we need to know if 'first_of_Series' scope is applied
        # for that, we need to add behavior to 'scope' (ActiveRecord::Scoping::Named::ClassMethods)
        # and, on an instance, to keep the 'collection where it come from' intel (?? ennumerable first, etc ??)
        def series_title
          "#{ __getobj__.title } <small><i class='no-warp'>(vol #{ position_in_series })</i></small>".html_safe
        end

        def showcase_title
          "#{ __getobj__.title } <small><i class='no-warp'>(#{ series.size } vols)</i></small>".html_safe
        end

        # TODO: title don't work if there is no series
        # cause 'depend' stille define the method, but will return nil
        def title options = {}
          if showcase
            showcase_title
          else
            series_title
          end
        end

        # TODO: don't ssems to work in decorated obj
        def showcase
          scoped? :firsts_of_series
          # collection_context.then{ |collection| collection.scoped? :firsts_of_series }
        end

      end
    end

    depend on: :series do

      # # TODO: put default locales keys ("vol" is hard coded here) in cluster
      # # same for the 'title' methods before
      # # TODO: the "disabled" link for self doesn't work yet
      # # in fact, the collection does not use the "self" object, so the singleton_class is lost
      # def pagination_tag
      #   series.collection.decorate.map{ |x|
      #     if x === self
      #       x.disabled_pagination_link_to
      #     else
      #       x.pagination_link_to
      #     end
      #   }.reduce(:safe_concat)
      # end
      #
      # def pagination_link_to
      #   view.link_to "vol #{ position_in_series }", self, class: :btn
      # end
      #
      # def disabled_pagination_link_to
      #   view.content_tag :span, "vol #{ position_in_series }", class: :'btn-disabled'
      # end


      def navigation_tag
        view.content_tag :p do
          safe_buffer = ActiveSupport::SafeBuffer.new

          if following
            safe_buffer += view.link_to(following, class: :btn){ view.fa_icon('angle-left') + " Previous" }
          end

          if following && followed
            safe_buffer += " "
          end

          if followed
            safe_buffer += view.link_to(followed, class: :btn){ "Next ".html_safe + view.fa_icon('angle-right') }
          end

          safe_buffer
        end
      end
    end
  end



end
