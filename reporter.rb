require 'json'
require_relative 'features/support/api_helper.rb'

thumbnail = { 'url' => 'https://i.ytimg.com/vi/qh7LLydY8eo/maxresdefault.jpg' }
fields = []

fields.push({ 'name' => 'Gaitors', 'value' => 'GAJAKA' })
fields.push({ 'name' => 'AUTOMATIONS', 'value' => 'Bisk nofieloja' })

embed = []
embed.push({ 'Title' => 'QA TEST',
             'color' => 16711909,
             'fields' => fields,
             'thumbnail' => thumbnail })


payload = { 'content' => 'Gatis Vaitovskis', 'embeds' => embed }.to_json

response = post('https://discordapp.com/api/webhooks/393067525451022336/uz2WgUi_8-6oS9zy2Pu_3l_-CtQvabdSlgflF_ojyxTxWgxO_8Vdj0qBDMNixDj6wlT1',
                headers: { 'Content-Type' => 'application/json' },
                cookies: {},
                payload: payload)