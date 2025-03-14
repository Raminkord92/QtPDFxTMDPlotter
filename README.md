# PDFxTMD

PDFxTMD is a library for parton distribution functions (PDFs) that integrates both collinear PDFs (cPDFs) and transverse momentum-dependent PDFs (TMDs). It is designed with modern C++ principles to achieve high performance and extensibility. The library provides interfaces for reading PDF grid files and supports standard formats from LHAPDF and TMDLib, while allowing adaptability to non-standard formats. 

For a comprehensive understanding of PDFxTMD, please refer to the full paper available on https://arxiv.org/abs/2412.16680. There's a <span style="color: red;">bug </span>in cPDF case when the grid file is comprised of multiple subgrids which is now fixed, but my releases still have this bug!

## Installation

To install PDFxTMD, please refer to the [INSTALL](INSTALL) file. Also, check this [site](https://raminkord92.github.io/PDFxTMD/) for more information.
## Quick Start

### 0. Requirements
1. Install g++:
   ```bash
   sudo apt install g++
   ```
2. Install GSL (GNU Scientific Library) development files:
   ```bash
   sudo apt install libgsl-dev
   ```

### 1. Download the Release
Download the `.deb` file (limited to Ubuntu or Ubuntu-based OS) from the [Releases](https://github.com/your-repo/releases) section of GitHub. For example, download the current release: `PDFxTMDLib-0.1.1-Linux.deb`.

### 2. Install the Library
Install the downloaded file using the following command (replace the filename with the latest release):
```bash
sudo dpkg -i PDFxTMDLib-0.1.1-Linux.deb
```

### 3. Write Your Program
Create a `main.cpp` file with the following code:

```cpp
#include <iostream>
#include <PDFxTMDLib/Factory.h>

int main()
{
    using namespace PDFxTMD;
    GenericCPDFFactory cPDF;
    auto CJ12min = cPDF.mkCPDF("CJ12min", 0);
    double x = 0.01;
    double mu2 = 100;
    std::cout << CJ12min.pdf(PartonFlavor::u, x, mu2) << std::endl;

    return 0;
}
```

### 4. Compile Your Program
Compile the program using the following command:
```bash
g++ main.cpp -I/usr/include/PDFxTMDLib -lPDFxTMDLib -o test.out
```

### 5. Execute Your Program
Run the compiled program:
```bash
./test.out
```

### 6. Verify PDF Set Availability
If the specified PDF set (e.g., `CJ12min`) is available in the environment paths defined by `PDFxTMD_PATH`, the program will output the results directly. 

If the PDF set is not found, the program will guide you through:
1. Downloading the required PDF set.
2. Decompressing it to your desired location.

After setup, your program will calculate the results as expected!

## Usage

Here is a simple example of how to use PDFxTMD:

```cpp
    using namespace PDFxTMD;
    GenericTMDFactory PBTMDObj;
    auto PBTMDObj_ = PBTMDObj.mkTMD("PB-NLO-HERAI+II-2023-set2-qs=0.74", 0);
    double x = 0.0001;
    double kt2 = 10;
    double mu2 = 100;
    double gPBTMD = PBTMDObj_.tmd(PartonFlavor::g, x, kt2, mu2);
    std::cout << "Gluon TMD of PB is: " << gPBTMD << std::endl;
    
    GenericCPDFFactory ct18Obj;
    auto ct18Obj_ = ct18Obj.mkCPDF("CT18NLO", 0);
    double gCt18Obj_ = ct18Obj_.pdf(PartonFlavor::g, x, mu2);
    std::cout << "Gluon PDF of CT18 is: " << gCt18Obj_ << std::endl;
```

## Contributing

Contributions are welcome! If you are interested in contributing, please don't hesitate to contact me at [raminkord92@gmail.com](mailto:raminkord92@gmail.com).

## License

This project is licensed under the Creative Commons Attribution 4.0 International License. For more details, please see the [LICENSE](LICENSE) file.

## Contact

For any inquiries, please contact [raminkord92@gmail.com](mailto:raminkord92@gmail.com).
