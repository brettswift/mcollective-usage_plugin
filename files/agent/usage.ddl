metadata :name        => "usage",
:description          => "Checks resource usage",
:author               => "Brett Swift",
:license              => "MIT",
:version              => "0.1",
:url                  => "http://puppetlabs.com",
:timeout              => 120


action "isfull", :description => "Check disk space usage against threshold" do
  input :threshold,
        :prompt      => "Threshold to check",
        :description => "Percent to check against",
        :type        => :integer,
        :validation  => '.',
        :optional    => true,
        :maxlength   => 2

  output :status,
        :description => "Return status of disk check",
        :display_as  => "Return Status",
        :default     => "unknown"

  summarize do
      aggregate summary(:status)
    end
end
