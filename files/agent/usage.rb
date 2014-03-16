module MCollective
  module Agent
    class Usage<RPC::Agent

      action 'isfull' do
        # validate :threshold, Integer
        run_isfull :threshold
      end

      private
      def run_isfull()
        cmd = "/bin/df  -h | awk {'print $5'}" #--total

        dfout = `#{cmd}`

        dfout = dfout.split(/\r?\n/)
        dfout.each do |line|
          status = 0
          if line.include? '%'
            utilization = line.to_i
            if utilization > threshold
              status = 1
              reply[:usage] = utilization
            end
          end
        end

        reply[:status] = status

      end
    end
  end
end
