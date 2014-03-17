module MCollective
  module Agent
    class Usage<RPC::Agent

      action 'disk' do
        threshold = request[:threshold].to_i
        threshold = 80 if threshold = 0
        run_is_disk_full threshold
      end

      action 'mem' do
        threshold = request[:threshold].to_i
        threshold = 80 if threshold = 0
        run_is_mem_full threshold
      end

      action 'swap' do
        threshold = request[:threshold].to_i
        threshold = 40 if threshold = 0
        run_swap_check threshold
      end

      private
      def run_is_disk_full(threshold)
        cmd = "\/bin\/df  -h --total | awk '\{if (NR!=3) print $5; else print $4\}'"

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
      end

      def run_is_mem_full(threshold)
        cmd_percent_free = "free -m | awk '\/Mem:\/ \{ total=$2 \} \/buffers\\/cache\/ \{ used=$4 \} END \{ print used\/total\}'"

        percent_free = `#{cmd_percent_free}`.to_f * 100
        usage = percent_free.to_i

        cmd_free_mb = "free -m | awk '\/buffers\\/cache\/ \{ print $4 \}' "
        free_mem = `#{cmd_free_mb}`

        reply[:usage] = usage
        reply[:free_mb] = free_mem
        reply.fail "Memory usage exceeded threshold of #{threshold}" unless usage < threshold
      end


      def run_swap_check(threshold)
        cmd_swap = "free -m | awk '\/Swap:\/ \{ total=$2;  used=$3\} END \{ print used\/total\}'"

        percentage_swap = `#{cmd_swap}`.to_f * 100
        swap_usage = percentage_swap.to_i

        cmd_free_swap = "free -m | awk '\/Swap\/ \{ print $4 \}' "
        free_swap_mb = `#{cmd_free_swap}`

        reply[:usage] = swap_usage
        reply[:free_swap_mb] = free_swap_mb
        reply.fail "Swap usage exceeded threshold of #{threshold}" unless swap_usage < threshold
      end
    end
  end
end
