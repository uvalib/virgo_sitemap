module SitemapHelper
  SOLR_URL= ENV['SOLR_URL'] || raise("ENV['SOLR_URL'] is required.")
  CHUNK_SIZE=100000

  def solr_params_start_at start_at
    @solr_params ||= {q: 'shadowed_location_facet:"VISIBLE"', fl: 'id,timestamp', wt: 'csv', rows: CHUNK_SIZE}
    @solr_params.merge({start: start_at})
  end

  def catalog_path id
    "/catalog/#{id}"
  end
end
