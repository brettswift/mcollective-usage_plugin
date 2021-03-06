metadata :name        => "usage",
:description          => "Checks resource usage",
:author               => "Brett Swift",
:license              => "MIT",
:version              => "0.1",
:url                  => "http://puppetlabs.com",
:timeout              => 120


action "disk", :description => "Check disk space usage against threshold" do
  input :threshold,
        :prompt      => "Threshold to check (%)",
        :description => "Percent to check against",
        :type        => :string,
        :validation  => '^[0-9]{2}',
        :optional    => true,
        :maxlength   => 2

  output :usage,
         :description => "Percent of highest usage disk",
         :display_as  => "Highest Disk Usage %",
         :default     => "unknown"

  output :offending_disk,
         :description => "Mount point with highest usage",
         :display_as  => "Disk with highest usage",
         :default     => "unknown"
end

action "mem", :description => "Check free memory usage against threshold (using buffers/cache)" do
 input :threshold,
       :prompt      => "Threshold to check usage above (%)",
       :description => "Percent to check against for machines over the threshold",
       :type        => :string,
       :validation  => '^[0-9]{2}',
       :optional    => true,
       :maxlength   => 2

 output :usage,
        :description => "Memory Usage %",
        :display_as  => "Memory Usage %",
        :default     => "unknown"
end

action "mem_underutilized", :description => "Check free memory usage against threshold (using buffers/cache)" do
 input :threshold,
       :prompt      => "Threshold to check usage below (%)",
       :description => "Percent to check against for machines under the threshold",
       :type        => :string,
       :validation  => '^[0-9]{2}',
       :optional    => true,
       :maxlength   => 2

 output :usage,
        :description => "Memory Usage %",
        :display_as  => "Memory Usage %",
        :default     => "unknown"
end

action "swap", :description => "Check swap usage against threshold" do
 input :threshold,
       :prompt      => "Threshold to check (%)",
       :description => "Percent to check against",
       :type        => :string,
       :validation  => '^[0-9]{2}',
       :optional    => true,
       :maxlength   => 2

 output :usage,
        :description => "Swap Usage %",
        :display_as  => "Swap Usage %",
        :default     => "unknown"

end
