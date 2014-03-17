module MCollective
  module Agent
    class Usage<RPC::Agent

      action 'disk' do
        threshold = 80 unless request[:threshold]
        run_is_disk_full threshold.to_i
      end

      action 'mem' do
        threshold = 80 unless request[:threshold]
        run_is_mem_full threshold.to_i
      end

      action 'swap' do
        threshold = request[:threshold]
        run_is_mem_full threshold.to_i
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

        reply[:usage] = highest_percent_full
        reply.fail "Disk usage exceeded threshold of #{threshold}" unless highest_percent_full < threshold
      end

      def run_is_mem_full(threshold)
        cmd_percent_free = "free -m | awk '\/Mem:\/ \{ total=$2 \} \/buffers\\/cache\/ \{ used=$4 \} END \{ print used\/total\}'"

        percent_free = `#{cmd_percent_free}`.to_f * 100
        usage = out.to_i

        cmd_free_mb = "free -m | awk '\/buffers\\/cache\/ \{ print $4 \}' "
        free_mem = `#{cmd_free_mb}`
        puts "free memory: #{free_mem}"

        reply[:usage] = usage
        reply[:free_mb] = free_mb
        reply.fail "Memory usage exceeded threshold of #{threshold}" unless usage < threshold
      end


      def run_is_swappy(threshold)
        cmd_swap = "free -m | awk '\/Swap:\/ \{ total=$2;  used=$3\} END \{ print used\/total\}'"

        out_swap = `#{cmdswap}`.to_f * 100
        swap_usage = out_swap.to_i

        cmd_free_swap = "free -m | awk '\/Swap\/ \{ print $4 \}' "
        free_swap_mb = `#{cmd_free_swap}`
        puts "free memory: #{free_mem}"

        reply[:usage] = usage
        reply[:free_swap_mb] = cmd_free_swap
        reply.fail "Swap usage exceeded threshold of #{threshold}" unless usage < threshold
      end
    end
  end
end
