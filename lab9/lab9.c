#include <security/pam_appl.h>
#include <security/pam_misc.h>
#include <stdio.h>

static struct pam_conv conv = {
    misc_conv,
    NULL
};

int main(int argc, char **argv) 
{
    pam_handle_t *pamh = NULL;
    int ret_val;
    const char *user = "nobody";

    if(argc == 2) 
    {
        user = argv[1];
    }

    if(argc > 2) 
    {
        fprintf(stderr, "Usage: check_user [username]\n");
        exit(1);
    }

    ret_val = pam_start("check", user, &conv, &pamh);

    if (ret_val == PAM_SUCCESS) {
        ret_val = pam_authenticate(pamh, 0);    
    }

    if (ret_val == PAM_SUCCESS) 
    {
        ret_val = pam_acct_mgmt(pamh, 0);       
    }

    if (ret_val == PAM_SUCCESS) 
    {
        fprintf(stdout, "Authenticated\n");
    } 
    else 
    {
        fprintf(stdout, "Not Authenticated\n");
    }

    printf("error code: %s\n", pam_strerror(pamh, ret_val));

    if (pam_end(pamh,ret_val) != PAM_SUCCESS) 
   {     
        pamh = NULL;
        fprintf(stderr, "Failed to release authenticator\n");
        exit(1);
    }

    return ( ret_val == PAM_SUCCESS ? 0:1 );       
}
