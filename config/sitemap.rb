require 'httparty'
require_relative 'sitemap_helper'

SitemapGenerator::Sitemap.default_host = "https://search.lib.virginia.edu"
SitemapGenerator::Sitemap.sitemaps_path = "sitemaps/"
SitemapGenerator::Interpreter.send :include, SitemapHelper

SitemapGenerator::Sitemap.create do
  start = 8000000
  finished = false
  puts "Generating Sitemap in chunks of #{CHUNK_SIZE}..."

  while !finished do
    puts "Loading chunk from solr starting at #{start}"
    http = HTTParty.get(SOLR_URL, query: solr_params_start_at(start) )
    row_count = 0

    CSV.parse(http.body, headers: true) do |row|
      add catalog_path(row['id']), lastmod: DateTime.parse(row['timestamp']), :changefreq => 'monthly'
      row_count += 1
    end

    if row_count < CHUNK_SIZE
      finished = true
    else
      start += CHUNK_SIZE
    end
  end

  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end

