<?php
/* Pi-hole: A black hole for Internet advertisements
 * (c) 2017 Pi-hole, LLC (https://pi-hole.net)
 * Network-wide ad blocking via your own hardware.
 *
 * This file is copyright under the latest version of the EUPL.
 * Please see LICENSE file for your rights under this license
 */

if (!isset($api)) {
    exit('Direct call to api_FTL.php is not allowed!');
}

// Initialize data array
$data = [];

if (isset($_GET['type'])) {
    $data['type'] = 'FTL';
}

if (isset($_GET['version'])) {
    $data['version'] = 3;
}

if (isset($_GET['status']) && $auth) {
    $data = getStatusData($data);
}

if ((isset($_GET['summary']) || isset($_GET['summaryRaw']) || !count($_GET)) && $auth) {
    require_once 'scripts/pi-hole/php/gravity.php';
    $data = getSummaryData($data);
}

if (isset($_GET['getMaxlogage']) && $auth) {
    $data = getMaxLogAgeData($data);
}

if (isset($_GET['overTimeData10mins']) && $auth) {
    $data = getOverTimeData($data);
}

if (isset($_GET['topItems']) && $auth) {
    $data = getTopItemsData($data);
}

if ((isset($_GET['topClients']) || isset($_GET['getQuerySources'])) && $auth) {
    $data = getTopClientsData($data);
}

if (isset($_GET['topClientsBlocked']) && $auth) {
    $data = getTopBlockedClientsData($data);
}

if (isset($_GET['getForwardDestinations']) && $auth) {
    $data = getForwardDestinationsData($data);
}

if (isset($_GET['getQueryTypes']) && $auth) {
    $data = getQueryTypesData($data);
}

if (isset($_GET['getCacheInfo']) && $auth) {
    $data = getCacheInfoData($data);
}

if (isset($_GET['getAllQueries']) && $auth) {
    $data = getAllQueriesData($data);
}

if (isset($_GET['recentBlocked']) && $auth) {
    $data = getRecentBlockedData($data);
}

if (isset($_GET['getForwardDestinationNames']) && $auth) {
    $data = getForwardDestinationNamesData($data);
}

if (isset($_GET['overTimeDataQueryTypes']) && $auth) {
    $data = getOverTimeDataQueryTypes($data);
}

if (isset($_GET['getClientNames']) && $auth) {
    $data = getClientNamesData($data);
}

if (isset($_GET['overTimeDataClients']) && $auth) {
    $data = getOverTimeDataClients($data);
}

if (isset($_GET['delete_lease']) && $auth) {
    $data = deleteLeaseData($data);
}

if (isset($_GET['dns-port']) && $auth) {
    $data = getDnsPortData($data);
}

// Output the data as JSON
header('Content-type: application/json');
echo json_encode($data);
exit;

// Functions to fetch data

function callFTLAPI($command)
{
    // Function implementation here
}

function getStatusData($data)
{
    // Function implementation here
}

function getSummaryData($data)
{
    // Function implementation here
}

function getMaxLogAgeData($data)
{
    // Function implementation here
}

function getOverTimeData($data)
{
    // Function implementation here
}

function getTopItemsData($data)
{
    // Function implementation here
}

function getTopClientsData($data)
{
    // Function implementation here
}

function getTopBlockedClientsData($data)
{
    // Function implementation here
}

function getForwardDestinationsData($data)
{
    // Function implementation here
}

function getQueryTypesData($data)
{
    // Function implementation here
}

function getCacheInfoData($data)
{
    // Function implementation here
}

function getAllQueriesData($data)
{
    // Function implementation here
}

function getRecentBlockedData($data)
{
    // Function implementation here
}

function getForwardDestinationNamesData($data)
{
    // Function implementation here
}

function getOverTimeDataQueryTypes($data)
{
    // Function implementation here
}

function getClientNamesData($data)
{
    // Function implementation here
}

function getOverTimeDataClients($data)
{
    // Function implementation here
}

function deleteLeaseData($data)
{
    // Function implementation here
}

function getDnsPortData($data)
{
    // Function implementation here
}
