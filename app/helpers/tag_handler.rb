class TagHandler 
  def wasAlreadySearched?(tag)
    _used_tag = UsedTag.where(tag: tag).first
    _used_tag.nil? ? false : true
  end
  def saveTag(tag)
    used_tag = UsedTag.new(tag: tag)
    used_tag.save
  end
  def getTags 
    return filter_tags(UsedTag.all)
  end
  def cleanTags 
    return UsedTag.delete_all
  end

  private 

  def filter_tags(tags)
    filtered = []
    tags.each do |tag|
      filtered.push(tag.attributes.slice('tag'))
    end
    return filtered.empty? ? Array.new : filtered
  end
end