# Synchronous FIFO Verification

This project focuses on the **functional verification of a parameterized Synchronous FIFO (First-In First-Out)** digital design using a **SystemVerilog-based verification environment**.  

---

## 📘 Overview

The **Synchronous FIFO** is a crucial component in digital systems, ensuring reliable data transfer between modules sharing a single clock domain.  
The main goal of this project was to verify the design’s **correctness, robustness, and compliance with its functional specifications** using an **industry-standard verification flow**.

---

## ⚙️ Features & Methodology

- **Verification Environment:** Developed entirely in **SystemVerilog**  
- **Methodology:** **Coverage-Driven Verification (CDV)**  
- **Stimulus Generation:** Constrained-random test scenarios  
- **Reference Model:** A **Scoreboard** to validate data integrity  
- **Coverage Metrics:**  
  - ✅ 100% **Functional Coverage**  
  - ✅ 100% **Code Coverage (Statement, Branch, Toggle)**  
- **Assertions:** Used to ensure protocol correctness and detect invalid scenarios  
- **Bug Fixes:** Multiple RTL issues were identified and corrected during verification

---

## 🧠 Key Verification Components

| Component | Description |
|------------|-------------|
| **Testbench** | Top-level module connecting all verification components |
| **Driver / Monitor** | Handles stimulus generation and data sampling |
| **Scoreboard** | Compares DUT output against the golden reference model |
| **Functional Coverage** | Measures design feature verification completeness |
| **Assertions** | Validates protocol and timing relationships |

---

## 💻 Tools Used

- **Language:** SystemVerilog  
- **Simulator:** ModelSim / QuestaSim  
- **Methodology:** System Verilog environment (non-UVM)  
- **Waveform Analysis:** Questasim viewer
---

## 📈 Verification Highlights

- Verified correct FIFO data ordering and timing behavior.  
- Validated full, empty, almost full, overflow, and underflow conditions.  
- Ensured proper recovery after reset.  
- Verified edge cases like simultaneous read and write operations.

---

## 🔗 Repository Structure
```
├── doc
│   ├── Verification Plan
│   │   └── FIFO.xlsx
│   └── FIFO_Report.pdf
├── rtl
│   ├── DesignBeforeChanges
│   │   └── FIFO.sv
│   └── FIFO.sv
├── sim
│   ├── run.do
│   └── src_files.list
├── tb
│   ├── FIFO_coverage.sv
│   ├── FIFO_if.sv
│   ├── FIFO_monitor.sv
│   ├── FIFO_scoreboard.sv
│   ├── FIFO_tb.sv
│   ├── FIFO_top.sv
│   ├── FIFO_transaction.sv
│   └── shared_pkg.sv
└── README.md
```
---

## 🙏 Acknowledgment

This project was completed **under the supervision and guidance of Eng. Kareem Waseem**, whose mentorship was invaluable in understanding advanced verification methodologies.

