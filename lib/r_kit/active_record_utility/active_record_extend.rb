module RKit::ActiveRecordUtility::ActiveRecordExtend

  def collection_finder **options
    all
      .then(if: :acts_as_poolables?){ |collection| collection.pool options[:pool] }
      .then(if: :acts_as_publishables?){ |collection| collection.published.publication_desc }
      .then(if: :acts_as_seriables?){ |collection| collection.series options[:series] }
  end

  def instance_finder **options
    if acts_as_taggables?
      tagged options[:tag]
    else
      find_by id: options[:id]
    end
  end


  ActiveRecord::Base.extend self
end
