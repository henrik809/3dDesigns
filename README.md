# 3dDesigns

My collection of 3D-printable designs: source CAD files, print-ready models, and notes.

## Repository Structure

```
3dDesigns/
├── projects/            # One folder per design
│   └── _template/       # Copy this to start a new project
│       ├── source/      # Editable CAD (SCAD, STEP, F3D, FCStd)
│       ├── models/      # Print-ready exports (STL, 3MF)
│       ├── prints/      # Photos of finished prints
│       ├── docs/        # Drawings, references, instructions
│       └── README.md    # Description and print settings
├── shared/
│   ├── parts/           # Reusable components (screws, mounts, brackets)
│   └── libraries/       # Shared CAD libraries and modules
├── LICENSE
└── README.md
```

## Starting a New Project

```bash
cp -r projects/_template projects/my-new-design
```

Then edit `projects/my-new-design/README.md` with the description and print settings.

## Conventions

- **Folder names:** lowercase, hyphen-separated (`desk-cable-clip`).
- **File names:** descriptive, with a version suffix for revisions (`bracket_v2.stl`).
- **Source of truth:** keep editable source in `source/`; treat `models/` as generated output.
- **Units:** millimetres unless a project's README says otherwise.
- **Print settings:** record what actually worked in each project's README.

## Projects

| Project | Description | Status |
|---|---|---|
| [Pixel 10 Pro Folding Stand](projects/pixel-10-pro-folding-stand) | Print-in-place phone stand that folds flat | Untested |

## License

See [LICENSE](LICENSE).
