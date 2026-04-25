{ config, pkgs, ... }:
{
  services.borgbackup.repos.barium = {
    path = "/bigmedia/backup/barium";
    authorizedKeys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC1SJkGjqwBV9N6Ity6u5acO4Nngo/MB/+1fUK4qC9zOXci4LZNPqqPERKUpClSvs3LeCX6JDokvY8Kr1CWuOGB1VRXajb5vhOklZXtMQYYKK4nHdkLtQ5+SpdCMvSXaum1jV49rvaoxkWCZSO/JK+jLIW3oQlUxlECIR7AkByMHSe2Nyt34CZ8P4iGiSDJowgSOa15Ca9Cl1I1goXbJwzfqDVmPPwlXJltJgntWr5Fbig7We5fakPnCsxFYrvKrz8tne1uEud3tLooLzvtaxKu32v69sLgFgeSAqkUE3T9CDCZhzipfJa+n3kSMF3EfJoHBr3apOdFBFtdeK6RKw5M57Ev/UnDIIxf0OVpivvtlqG7vYhCWDZ+ZaeUkil68+eKvVP9BW46kgN0rtQTjAgCAeLEInIVmI0m2fXwVVuZlMtwOL6ILKeMpD2z7twvzKOdngFdkkiVUVguGYZll88jl7TDgzzk+wt7CWCgcdN6cUwxMralb8sy5tXST/8Gdlk= barium@luko.dev" ];
  };
}
