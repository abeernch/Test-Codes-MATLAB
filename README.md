# Test-Codes-MATLAB

MATLAB scripts used to prototype, verify, and visualize pieces of a larger
radar and geolocation workflow. The repository is a working code collection,
not a packaged application.

The scripts cover a broad set of experiments:

- TDoA and related multilateration tests.
- PDW, PRI, pulse, bandwidth, and waveform experiments.
- Radar scenario, tracking, and platform-motion simulations.
- TCP, UDP, and data-transfer checks.
- Plotting helpers, hover tooltips, and interactive figure utilities.
- Error ellipses, range, bearing, and geometry calculations.
- Miscellaneous math and signal-processing test scripts.

## Repository Layout

| Path | Purpose |
| --- | --- |
| `Test Scripts/` | PDW, PRI, scenario, networking, and radar test harnesses. |
| `Test Scripts TDOA/` | TDoA, GDoP, CEP, isochrone, hyperbola, and multilateration experiments. |
| `Functions/` | Shared helper functions reused across multiple scripts. |
| Root-level `test_*.m` files | Standalone experiments and single-file validation scripts. |
| Root-level utility files | General helpers such as plotting, constants, or one-off analysis tools. |

## What this repo is for

1. Prototyping individual radar and geolocation building blocks.
2. Verifying algorithms before they are promoted into larger systems.
3. Keeping short, reproducible MATLAB examples for specific behaviors.
4. Preserving older analysis scripts that are still useful as references.

## Getting Started

1. Open the repository in MATLAB.
2. Add the repository root to the MATLAB path, including subfolders.
3. Start with the script that matches the behavior you want to inspect.
4. Read the first section of the file before running it, because many scripts
   are intended as experiments rather than polished functions.

## Common Script Families

- `test_prx_*.m` and `test_bw_*.m`: waveform, bandwidth, and pulse-response work.
- `test_pdw_*.m`, `Test Scripts/PDWSimulator_230515.m`: PDW generation and
  emitter-activity experiments.
- `test_tdoa_*.m`, `Test Scripts TDOA/`: TDoA geometry, multilateration, and
  error metrics.
- `test_scenario_*.m`, `test_tracking_scenario_*.m`: radar scenario and motion
  simulation.
- `test_tcpclient_*.m`, `test_TCPIP_UDP_*.m`, `test_UDP_sendRec_*.m`: network
  transport examples.
- `test_hoverTooltipplotting_*.m`, `moveplot.m`: interactive plotting helpers.

## Documentation Scope

Public documentation in this repository stays generic. Deployment-specific site
names, coordinates, and other location identifiers are intentionally not called
out in the docs.

## License

Released under the MIT License. See [LICENSE](LICENSE).
