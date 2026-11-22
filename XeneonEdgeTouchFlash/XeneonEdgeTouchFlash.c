// GPLv3 license. See LICENSE file for more information.
// Created by Andrew Hirst

#include <stdio.h>
#include <Windows.h>

typedef DWORD (__stdcall *ScanRunDevices_fn)();
ScanRunDevices_fn ScanRunDevices = NULL;

typedef DWORD (__stdcall *GetDeviceFwVersion_fn)(DWORD idx, LPSTR version, DWORD versionLength);
GetDeviceFwVersion_fn GetDeviceFwVersion = NULL;

typedef DWORD (__stdcall* EnterIAPMode_fn)(DWORD idx);
EnterIAPMode_fn EnterIAPMode = NULL;

typedef DWORD (__stdcall* ScanIAPDevices_fn)();
ScanIAPDevices_fn ScanIAPDevices = NULL;

typedef void (__stdcall* ProgressCallback_t)(DWORD percent);
typedef DWORD (__stdcall* DeviceFwUpgrade_fn)(DWORD idx, LPCSTR fwFileName, ProgressCallback_t cb);
DeviceFwUpgrade_fn DeviceFwUpgrade = NULL;

HMODULE hDll;

#define LOAD_DLL_FN(fnName) fnName = (fnName ## _fn)GetProcAddress(hDll, #fnName); if (fnName == NULL) goto FN_ERR;

void __stdcall FlashProgress(DWORD percent)
{
    printf("Progress %d%%...\n", percent);
}

int main(int argc, char* argv[])
{
    if (argc != 2)
    {
        printf("Please input a firmware file as a command line argument.\n");
        return 0;
    }

    CHAR fileName[MAX_PATH + 1];
    DWORD len = GetFullPathNameA(argv[1], sizeof(fileName), fileName, NULL);
    if (len == 0)
    {
        fprintf(stderr, "Failed to resolve the absolute path for the firmwre file. Error %d.\n", GetLastError());
        return -1;
    }
    else if (len > sizeof(fileName))
    {
        fprintf(stderr, "The absolute path for the firmware file is too long.\n");
        return -1;
    }

    DWORD fileAttribs = GetFileAttributesA(fileName);
    if (fileAttribs == INVALID_FILE_ATTRIBUTES || (fileAttribs & FILE_ATTRIBUTE_DIRECTORY))
    {
        printf("The specified firmware file does not exist.\n");
        return -1;
    }

    printf("Please note that XLIAPApi.dll can produce garbled output to the console. This is expected behaviour.\n");
    printf("!!! WARNING: This tool does not check the validity of the file supplied. !!!\nPress enter to continue...\n");
    getc(stdin);

    printf("Loading...\n");

    hDll = LoadLibraryA("XLIAPApi.dll");
    if (hDll == NULL)
    {
        fprintf(stderr, "Failed to load XLIAPApi.dll. Please place the DLL in the same directory as this EXE. Error %d.\n", GetLastError());
        return -1;
    }

    LOAD_DLL_FN(ScanRunDevices);
    LOAD_DLL_FN(GetDeviceFwVersion);
    LOAD_DLL_FN(EnterIAPMode);
    LOAD_DLL_FN(ScanIAPDevices);
    LOAD_DLL_FN(DeviceFwUpgrade);

    DWORD err = ERROR_SUCCESS;

    printf("Scanning for devices...\n");

    DWORD num = ScanRunDevices();
    for (DWORD i = 0; i < num; i++)
    {
        CHAR version[16];
        err = GetDeviceFwVersion(i, version, sizeof(version));
        if (err != ERROR_SUCCESS)
        {
            fprintf(stderr, "Failed to get a device firmware version. Error %d.\n", err);
            return -1;
        }

        printf("Putting device %d (firmware version: %s) into IAP mode...\n", i, version);

        err = EnterIAPMode(i);
        if (err != ERROR_SUCCESS)
        {
            fprintf(stderr, "Failed to put device %d into IAP mode. Error %d.\n", i, err);
        }
    }

    printf("Sleeping for 5 seconds to let devices reconnect in IAP mode...\n");
    Sleep(5000);

    printf("Scanning for devices in IAP mode...\n");
    num = ScanIAPDevices();
    for (DWORD i = 0; i < num; i++)
    {
        printf("Found device %d. Flashing...\n", i);
        err = DeviceFwUpgrade(i, fileName, FlashProgress);
        if (err != ERROR_SUCCESS)
        {
            fprintf(stderr, "Failed to flash device %d. Error %d.\n", i, err);
        }
    }

    printf("Done!\n");
    goto EXIT;
FN_ERR:
    fprintf(stderr, "Failed to get a function pointer from XLIAPApi.dll.");
EXIT:
    FreeLibrary(hDll);
    return 0;
}

