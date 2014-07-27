module RKit::ActiveRecordUtility::Utilities::Tag
  extend ActiveSupport::Concern

  included do
    validates_presence_of :tag
    validates_uniqueness_of :tag

    def to_param() tag end
    def self.tagged(tag) where(tag: tag).first end
  end
end
