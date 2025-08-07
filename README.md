# 🛠️ Windows Deployment Scripts (MBR & GPT)

Collection of batch scripts to automate the partitioning and deployment of Windows using `.wim` images, supporting both **MBR (BIOS/Legacy)** and **GPT (UEFI)** partitioning styles.

> ⚠️ **WARNING:** These scripts will erase all data on the selected disk. Use with extreme caution.

---

## 📁 Included Scripts

| Script Name               | Purpose                                                                 |
|---------------------------|-------------------------------------------------------------------------|
| `1_GPT_Partitioner.bat`       | Partitions a disk as GPT for UEFI systems                           |
| `1_MBR_Partitioner.bat`       | Partitions a disk as MBR for BIOS/Legacy systems                    |
| `2_GPT_WimApplier.bat`    | Applies a WIM image and sets up UEFI bootloader                         |
| `2_MBR_WimApplier.bat`    | Applies a WIM image and sets up BIOS bootloader with MBR rewrite        |

---

## 🧱 Requirements

- Windows PE / recovery environment or similar
- Administrator privileges
- A valid `.wim` Windows image (e.g. from installation media)
- DiskPart, DISM, BCDBoot, and BootSect (all included in Windows PE)

---

## ⚙️ How to Use

### 1. Prepare USB with WinPE + Scripts
Place these scripts and the `.wim` file on a USB stick or external drive.

### 2. Boot into WinPE
Boot the target machine using your prepared USB or recovery ISO.

### 3. Run the Scripts

#### ▶️ GPT (UEFI) Workflow
```bat
1_GPT_Partitioner.bat
```
- Cleans and partitions the selected disk using GPT
- Creates EFI, MSR, and Windows partitions

```bat
2_GPT_WimApplier.bat
```
- Prompts for WIM path, image index, partition letters
- Applies the image and configures UEFI boot

#### ▶️ MBR (BIOS) Workflow
```bat
1_MBR_Partitioner.bat
```
- Cleans and partitions the selected disk using MBR
- Creates System Reserved and Windows partitions

```bat
2_MBR_WimApplier.bat
```

- Prompts for WIM path, image index, partition letters
- Applies the image and configures BIOS boot
- Rewrites MBR boot code with bootsect

#### 📌 Example File Structure
```
/
├── 1_GPT_Partitioner.bat
├── 1_MBR_Partitioner.bat
├── 2_GPT_WimApplier.bat
├── 2_MBR_WimApplier.bat
├── install.wim
```

#### ⚠️ Disclaimers
- These scripts are provided as-is and should be tested in a safe environment before use in production.
- Always double-check disk numbers and drive letters before proceeding.
- No warranty is provided. Use at your own risk.
