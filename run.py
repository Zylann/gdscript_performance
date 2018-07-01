import os
import subprocess
import shutil

GODOT_BINARIES_FOLDER = "D:/PROJETS/INFO/GODOT/bin"
LAST_RESULTS_FILE = "results/last_results.json"
ITERATIONS = 1000000
#ITERATIONS = 1000
VERBOSE = False

VERSIONS = [
    { "v": [1, 1], "x": "Godot_v1.1_stable_win64.exe" },

    { "v": [2, 0, 0], "x": "godot_2_0_0.exe" },
    { "v": [2, 0, 2], "x": "godot_2_0_2.exe" },
    { "v": [2, 0, 3], "x": "godot_2_0_3.exe" },
    { "v": [2, 0, 4, 1], "x": "Godot_v2.0.4.1_stable_win64.exe" },
    { "v": [2, 0, 4], "x": "Godot_v2.0.4_stable_win64.exe" },

    { "v": [2, 1], "x": "Godot_v2.1_beta_20160712_win64.exe" },
    { "v": [2, 1], "x": "Godot_v2.1_rc1_win64.exe" },
    { "v": [2, 1], "x": "Godot_v2.1_rc2_win64.exe" },
    { "v": [2, 1], "x": "Godot_v2.1-stable_win64.exe" },
    { "v": [2, 1, 1], "x": "Godot_v2.1.1-stable_win64.exe" },
    { "v": [2, 1, 2], "x": "Godot_v2.1.2-stable_win64.exe" },
    { "v": [2, 1, 3], "x": "Godot_v2.1.3-stable_win64.exe" },
    { "v": [2, 1, 4], "x": "Godot_v2.1.4-beta_20170625_win64.exe" },
    { "v": [2, 1, 4], "x": "Godot_v2.1.4-beta_20170731_win64.exe" },
    { "v": [2, 1, 4], "x": "Godot_v2.1.4-stable_win64.exe" },

    { "v": [3, 0], "x": "Godot_v3.0-alpha1_win64.exe" },
    { "v": [3, 0], "x": "Godot_v3.0-alpha2_win64.exe" },
    { "v": [3, 0], "x": "Godot_v3.0-beta1_win64.exe" },
    { "v": [3, 0], "x": "Godot_v3.0-beta2_win64.exe" },
    { "v": [3, 0], "x": "Godot_v3.0-rc1_win64.exe" },
    { "v": [3, 0], "x": "Godot_v3.0-rc2_win64.exe" },
    { "v": [3, 0], "x": "Godot_v3.0-rc3_win64.exe" },
    { "v": [3, 0], "x": "Godot_v3.0-stable_win64.exe" },
    { "v": [3, 0, 1], "x": "Godot_v3.0.1-rc1_win64.exe"},
    { "v": [3, 0, 1], "x": "Godot_v3.0.1-stable_win64.exe"},
    { "v": [3, 0, 2], "x": "Godot_v3.0.2-stable_win64.exe"},
    { "v": [3, 0, 3], "x": "Godot_v3.0.3-rc1_win64.exe"},
    { "v": [3, 0, 3], "x": "Godot_v3.0.3-rc3_win64.exe"},
    { "v": [3, 0, 3], "x": "Godot_v3.0.3-stable_win64.exe"},
    { "v": [3, 0, 4], "x": "Godot_v3.0.4-stable_win64.exe"}
]


def main():
    print("Hello!")
    if not check_paths():
        return

    versions = VERSIONS #[{ "v": [3, 0], "x": "Godot_v3.0-stable_win64.exe" }]
    for version_info in versions:
        v = version_info["v"]
        # if not (v[0] == 2 and v[1] == 0 and len(v) == 3 and v[2] == 0):
        #     continue
        test_version(v, version_info["x"])
    print("Done")


def check_paths():
    ok = True
    for version_info in VERSIONS:
        path = os.path.join(GODOT_BINARIES_FOLDER, version_info["x"])
        if not os.path.isfile(path):
            print("ERROR: path", path, "doesn't exist")
            ok = False
    return ok


def test_version(version, godot_exe_name):

    print("Running ", godot_exe_name, "...")
    godot_exe_fullpath = os.path.join(GODOT_BINARIES_FOLDER, godot_exe_name)

    if os.path.isfile(LAST_RESULTS_FILE):
        os.remove(LAST_RESULTS_FILE)

    args = [godot_exe_fullpath, "--iterations=" + str(ITERATIONS)]
    if not VERBOSE:
        args.append("--noprint")

    os.chdir("project" + str(version[0]))
    subprocess.run(args)
    os.chdir("..")

    print("")
    if not os.path.isfile(LAST_RESULTS_FILE):
        print("Something went wrong with the results.")
    else:
        godot_name = os.path.splitext(godot_exe_name)[0]
        shutil.copyfile(LAST_RESULTS_FILE, "results/" + godot_name + ".json")
        # TODO Remove last results file! That should be a rename


main()
