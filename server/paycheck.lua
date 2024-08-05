function StartPayCheck()
  CreateThread(function()
    while true do
      Wait(Config.PaycheckInterval)
      for player, xPlayer in pairs(ESX.Players) do
        local jobLabel = xPlayer.job.label
        local job = xPlayer.job.grade_name
        local vip = xPlayer.metadata.vip
        local salary = xPlayer.job.grade_salary
        if vip then
          salary = salary * 2
        end
        if salary > 0 then
          if job == 'unemployed' then -- unemployed
            local pc = xPlayer.getMeta('paycheck')
            if not pc then
              xPlayer.setMeta('paycheck', salary)
            else
              xPlayer.setMeta('paycheck', pc + salary)
            end
            lib.notify(player, {
                title = 'Pay Check',
                description = ('Kamu menerima paycheck senilai: **%s**'):format(lib.math.groupdigits(salary)),
                type = 'info',
                icon = 'fas fa-building-columns',
            })
            if Config.LogPaycheck then
              ESX.DiscordLogFields("Paycheck", "Paycheck - Unemployment Benefits", "green", {
                { name = "Player", value = xPlayer.name,   inline = true },
                { name = "ID",     value = xPlayer.source, inline = true },
                { name = "Amount", value = salary,         inline = true }
              })
            end
          elseif Config.EnableSocietyPayouts then -- possibly a society
            TriggerEvent('esx_society:getSociety', xPlayer.job.name, function(society)
              if society ~= nil then              -- verified society
                TriggerEvent('esx_addonaccount:getSharedAccount', society.account, function(account)
                  if account.money >= salary then -- does the society money to pay its employees?
                    xPlayer.addAccountMoney('bank', salary, "Paycheck")
                    account.removeMoney(salary)
                    if Config.LogPaycheck then
                      ESX.DiscordLogFields("Paycheck", "Paycheck - " .. jobLabel, "green", {
                        { name = "Player", value = xPlayer.name,   inline = true },
                        { name = "ID",     value = xPlayer.source, inline = true },
                        { name = "Amount", value = salary,         inline = true }
                      })
                    end

                    TriggerClientEvent('esx:showAdvancedNotification', player, TranslateCap('bank'), TranslateCap('received_paycheck'),
                      TranslateCap('received_salary', salary), 'CHAR_BANK_MAZE', 9)
                  else
                    TriggerClientEvent('esx:showAdvancedNotification', player, TranslateCap('bank'), '', TranslateCap('company_nomoney'), 'CHAR_BANK_MAZE', 1)
                  end
                end)
              else -- not a society
                local pc = xPlayer.getMeta('paycheck')
                if not pc then
                  xPlayer.setMeta('paycheck', salary)
                else
                  xPlayer.setMeta('paycheck', pc + salary)
                end
                lib.notify(player, {
                    title = 'Pay Check',
                    description = ('Kamu menerima paycheck senilai: **%s**'):format(lib.math.groupdigits(salary)),
                    type = 'info',
                    icon = 'fas fa-building-columns',
                })
                if Config.LogPaycheck then
                  ESX.DiscordLogFields("Paycheck", "Paycheck - " .. jobLabel, "green", {
                    { name = "Player", value = xPlayer.name,   inline = true },
                    { name = "ID",     value = xPlayer.source, inline = true },
                    { name = "Amount", value = salary,         inline = true }
                  })
                end
              end
            end)
          else -- generic job
            local pc = xPlayer.getMeta('paycheck')
            if not pc then
              xPlayer.setMeta('paycheck', salary)
            else
              xPlayer.setMeta('paycheck', pc + salary)
            end
            lib.notify(player, {
                title = 'Pay Check',
                description = ('Kamu menerima paycheck senilai: **%s**'):format(lib.math.groupdigits(salary)),
                type = 'info',
                icon = 'fas fa-building-columns',
            })
            if Config.LogPaycheck then
              ESX.DiscordLogFields("Paycheck", "Paycheck - Generic", "green", {
                { name = "Player", value = xPlayer.name,   inline = true },
                { name = "ID",     value = xPlayer.source, inline = true },
                { name = "Amount", value = salary,         inline = true }
              })
            end
          end
        end
      end
    end
  end)
end
