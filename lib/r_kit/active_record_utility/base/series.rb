class RKit::ActiveRecordUtility::Base::Series < RKit::ActiveRecordUtility::Base

  instance_interferences do
    has_one :followed, class_name: name, foreign_key: "following_id"
    belongs_to :following, class_name: name

    before_validation if: :following_id_changed? do
      self.title ||= following.title if __class__.column_exists? "title"
      self.series = following.series.name
    end




    # TODO: after save, if series change, all obj in series change

    # TODO: we can add a conditionnal validation on 'inclusion_in' (like pool)

    # TODO: validates presence of serie also on the followed record

    # TODO: validates a record can only have one follower (or is it hadled by the "has_one" relation directly ?)

    validates_presence_of :series, if: :following
    validates_uniqueness_of :following_id, if: :following

    scope :series, ->(series){ series && where(series: series) }

    # TODO: adapter le scope pour intégrer les published (si interfered)
    # je laisse en commentaire parceque j'aime pas le nom du scope,
    # et j'ai pas d'idée là maintenant (à part 'pilotes', ou 'firsts')
    # scope :firsts_of_series, ->{ where(following_id: nil) }

    # TODO: scope pour l'ordre dans une serie (pour le decorator pagination_tag)

    @@_active_record_utilities_series = {}
  end

  class_interferences do
    def series
      @@_active_record_utilities_series[read_attribute(:series)] ||= series_struct if read_attribute(:series)
      # TODO: if series cg-hanges, or new element added, series must be re-calculated
      # maybe pre-calc this in after save
    end

    def series_struct
      OpenStruct.new.tap do |series_struct|
        series_struct.name = read_attribute :series
        series_struct.collection = __class__.series series_struct.name
        series_struct.size = series_struct.collection.count
      end
    end

    def position_in_series
      following ? following.send(__method__) + 1 : 1
    end
  end

  decorator_interferences do
    after_initialize do
      # TODO: this can't stay this way, if "serie" is pre-calculated
      # & shared accros instances & kept in memory (class variable)

      # series.collection = series.collection.decorate if series
      # TODO: infinite loop, need a "unless" on the after_init, or smthng even more smart
      # ps: i'm not happy with this current decorate
    end

    def series_url
      view.url_for [__class__, series: series.name]
    end

    def link_to_series
      view.link_to series.name, series_url, class: :btn
    end

    if decorated_klass.columns_hash["title"]
      # I don't get this "showcase thing", we can delete that and just look into the view for the params
      # Or in the collection, to see if the scope is applied (second solution is better)
      def series_title
        "#{ __getobj__.title } <small><i class='no-warp'>(vol #{ position_in_series })</i></small>".html_safe
      end

      def showcase_title
        "#{ __getobj__.title } <small><i class='no-warp'>(#{ series.size } vols)</i></small>".html_safe
      end

      def title options = {}
        if series and false # and showcase
          showcase_title
        elsif series
          series_title
        else
          super()
        end
      end
    end

    # TODO: put default locales keys ("vol" is hard coded here) in cluster
    # same for the 'title' methods before
    # TODO: the "disabled" link for self doesn't work yet
    # in fact, the collection does not use the "self" object, so the singleton_class is lost
    def pagination_tag
      disable_pagination_link self
      series.collection.decorate.map(&:pagination_link_to).reduce(:safe_concat)
    end

    def pagination_link_to
      view.link_to "vol #{ position_in_series }", self, class: :btn
    end

    def disabled_pagination_link_to
      view.content_tag :span, "vol #{ position_in_series }", class: :'btn-disabled'
    end

    def disable_pagination_link seriable_instance
      class << seriable_instance
        alias :pagination_link_to :disabled_pagination_link_to
      end
    end


    # TODO: put default locales keys (:previous, :next) in cluster
    def navigation_tag
      view.content_tag :p do
        safe_buffer = ActiveSupport::SafeBuffer.new
        safe_buffer += view.link_to view.t(:previous), following, class: :btn if following
        safe_buffer += " "
        safe_buffer += view.link_to view.t(:next), followed, class: :btn if followed
        safe_buffer
      end
    end
  end


  def can_interfere?
    base.table_exists? &&
      base.column_names.include_all?(["following_id", "series"]) &&
      base.columns_hash["following_id"].type == :integer &&
      base.columns_hash["series"].type == :string
  end
end
