require 'json'
require_relative 'features/support/api_helper.rb'

build_number = ARGV[0]
job_url = ARGV[1]


thumbnail = { 'url' => 'https://i.ytimg.com/vi/qh7LLydY8eo/maxresdefault.jpg' }
fields = []

fields.push({ 'name' => 'Jenkins job', 'value' => job_url.to_s })
fields.push({ 'name' => 'Bildes numberas', 'value' => build_number.to_s })

embed = []
embed.push({
             'color' => 16711909,
             'fields' => fields,
             'thumbnail' => thumbnail })


payload = { 'content' => 'Gatis Vaitovskis', 'embeds' => embed }.to_json

response = post('https://discordapp.com/api/webhooks/393067525451022336/uz2WgUi_8-6oS9zy2Pu_3l_-CtQvabdSlgflF_ojyxTxWgxO_8Vdj0qBDMNixDj6wlT1',
                headers: { 'Content-Type' => 'application/json' },
                cookies: {},
                payload: payload)