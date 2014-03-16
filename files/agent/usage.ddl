metadata :name        => "usage",
:description          => "Checks resource usage",
:author               => "Brett Swift",
:license              => "MIT",
:version              => "0.1",
:url                  => "http://puppetlabs.com",
:timeout              => 120


action "disk", :description => "Check disk space usage against threshold" do
  input :threshold,
        :prompt      => "Threshold to check",
        :description => "Percent to check against",
        :type        => :string,
        :validation  => '^[0-9]{2}',
        :optional    => true,
        :maxlength   => 2,
        :default     => 80

  output :usage,
        :description => "Disk Usage %",
        :display_as  => "Disk Usage %",
        :default     => "unknown"

  summarize do
      aggregate summary(:usage)
    end
end
