require 'roda'

class Yapp < Roda
  # ----------------------------------------------------------
  # Plugins
  # ----------------------------------------------------------

  plugin :default_headers,
    'Content-Type'=>'application/json',
    #'Strict-Transport-Security'=>'max-age=16070400;', # Uncomment if only allowing https:// access
    'X-Frame-Options'=>'deny',
    'X-Content-Type-Options'=>'nosniff',
    'X-XSS-Protection'=>'1; mode=block'

  # ----------------------------------------------------------
  # Routing tree
  # ----------------------------------------------------------

  route do |r|
    r.on 'api' do
      r.on 'v1' do
        r.is 'registration' do
          # generate uuid and store client metrics
          r.post do
          end
        end

        r.is 'analyses' do
          # show all analyses scoped by user
          r.get do
          end

          # send the files for analysis
          r.post do
          end
        end
      end
    end
  end
end
