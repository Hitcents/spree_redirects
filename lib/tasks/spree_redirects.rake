namespace :spree_redirects do
  desc "Import redirects from csv specified by FILE. (format -- no header. just 2 columns: source, destination"
  task :import => :environment do

    file = ENV['FILE']

    CSV.foreach(file, converters: lambda { |f| f ? f.strip : nil }) do |row|
      source = row[0]
      destination = row[1]

      # delete any redirect rules with the new url as the source
      # For instance, if we're creating a redirect from A -> B,
      # we'd want to destroy any existing redirects that send B -> C.
      Spree::Redirect.where(old_url: destination).destroy_all

      # update redirects with the old url as the destination to prevent chains of redirects
      # For instance, if we're creating a redirect from A -> B, but Z -> A already exists, 
      # update Z -> A to say Z -> B to avoid Z -> A -> B
      Spree::Redirect.where(new_url: source).update_all(new_url: destination)

      # For instance, if A -> B exists, but we're creating A -> C, then remove A -> B
      Spree::Redirect.where(old_url: source).destroy_all

      # Now, actually create the desired redirect
      Spree::Redirect.create(old_url: source, new_url: destination) unless source == destination
    end
  end
end
