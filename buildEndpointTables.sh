#!/usr/bin/env bash
echo "Running script: buildEndpointTables.sh"
echo "Building out tables for endpoints..."
echo "This script should be run from the directory"
echo "~/data_infrastructure/"
echo "Current working directory:"
pwd

echo "Calling sudo ./endpoints/makeGrassState.R,"
echo "the script which orchestrates construction of"
echo "percent grass roots and percent instate data."
#build the endpoints table.
sudo ./endpoints/makeGrassState.R

echo "Running ./endpoints/campaign_detail/productionCampaignDetail.sql,"
echo "the script that produces the working campaign detail data."
sudo -u postgres psql hackoregon < ./endpoints/campaign_detail/productionCampaignDetail.sql

#candidateByState
echo "Running ./endpoints/candidateByState/candidate_by_state.sql,"
echo "the script that produces data for candidates by state."
sudo ./endpoints/candidateByState/buildCandidateByStateEndpoint.sh
