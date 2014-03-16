module MCollective
  module Agent
    class Usage<RPC::Agent

      action 'disk' do

        threshold = 80 unless request[:threshold]
        run_is_disk_full threshold.to_i
      end

      private
      def run_is_disk_full(threshold)
        cmd = "/bin/df  -h | awk {'print $5'}" #--total

        dfout = `#{cmd}`

        highest_percent_full = 0

        dfout = dfout.split(/\r?\n/)
        dfout.each do |line|
          if line.include? '%'
            utilization = line.to_i
            highest_percent_full = utilization if utilization > highest_percent_full
            if highest_percent_full > threshold
              reply[:usage] = utilization
            end
          end
        end

        reply[:usage] = highest_percent_full
        reply.fail "Usage exceeded threshold of #{threshold}. Was: #{highest_percent_full}" unless highest_percent_full < threshold
      end
    end
  end
end
