[Unit]
Description=backend script for the ngs_pipeline web frontend
After=rocks-tracker

[Service]
ExecStart=/usr/local/bin/ngs_pipeline_backend.pl ###OPTIONS_NGS_SGE###
Type=simple

[Install]
WantedBy=multi-user.target