<!--
Copyright 2021 Wuping Xin

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE. See the GNU General Public License for more details. You
should have received a copy of the GNU General Public License along with this
program. If not, see <http://www.gnu.org/licenses/>.

Markdown conversion of IEEE-29148-2018-SRS-Template.tex
(https://github.com/wxinix/IEEE-29148-SRS-LaTeX-Template).

This template is based on IEEE/ISO/IEC 29148-2018, Section 9.6.

This template provides the normative content of the software requirement
specification (SRS). The project shall produce the following information item
content in accordance with the project's policies with respect to the software
requirements specification. Organization of the content such as the order and
section structure may be selected in accordance with the project's information
management policies.
-->

# Software Requirements Specification

## for *My Super Cool Software*

**Version 1.0**

**Prepared by:** Your Name

**Organization:** Company Name

**Date:** YYYY-MM-DD

**Keywords:** SRS, ISO/IEC/IEEE 29148:2018

---

## Revision History

| Name | Date | Reason for Changes | Version |
|------|------|--------------------|---------|
|      |      |                    |         |
|      |      |                    |         |
|      |      |                    |         |

---

## Table of Contents

1. [Introduction](#1-introduction)
   - 1.1 [Purpose](#11-purpose)
   - 1.2 [Scope](#12-scope)
   - 1.3 [References](#13-references)
   - 1.4 [Terms](#14-terms)
   - 1.5 [Abbreviations](#15-abbreviations)
2. [Product Overview](#2-product-overview)
   - 2.1 [Product Perspective](#21-product-perspective)
     - 2.1.1 [System Interfaces](#211-system-interfaces)
     - 2.1.2 [User Interfaces](#212-user-interfaces)
     - 2.1.3 [Hardware Interfaces](#213-hardware-interfaces)
     - 2.1.4 [Software Interfaces](#214-software-interfaces)
     - 2.1.5 [Communication Interfaces](#215-communication-interfaces)
     - 2.1.6 [Memory Constraints](#216-memory-constraints)
     - 2.1.7 [Operations](#217-operations)
     - 2.1.8 [Site Adaptation Requirements](#218-site-adaptation-requirements)
     - 2.1.9 [Interface with Services](#219-interface-with-services)
   - 2.2 [Product Functions](#22-product-functions)
   - 2.3 [User Characteristics](#23-user-characteristics)
   - 2.4 [Limitations](#24-limitations)
   - 2.5 [Assumptions and Dependencies](#25-assumptions-and-dependencies)
   - 2.6 [Apportioning of Requirements](#26-apportioning-of-requirements)
   - 2.7 [Specified Requirements](#27-specified-requirements)
3. [Specific Requirements](#3-specific-requirements)
   - 3.1 [External Interfaces](#31-external-interfaces)
   - 3.2 [Functions](#32-functions)
   - 3.3 [Usability Requirements](#33-usability-requirements)
   - 3.4 [Performance Requirements](#34-performance-requirements)
   - 3.5 [Logical Database Requirements](#35-logical-database-requirements)
   - 3.6 [Design Constraints](#36-design-constraints)
   - 3.7 [Standards Compliance](#37-standards-compliance)
   - 3.8 [Software System Attributes](#38-software-system-attributes)
4. [Verification](#4-verification)
5. [Supporting Information](#5-supporting-information)

---

## 1. Introduction

### 1.1 Purpose

> **[IEEE-29148-2018 9.6.2]** Delineate the purpose of the software to be specified.

### 1.2 Scope

> **[IEEE-29148-2018 9.6.3]** Describe the scope of the software under consideration by:
>
> a) identifying the software product(s) to be produced by name (e.g., Host DBMS, Report Generator, etc.);
> b) explaining what the software product(s) will do;
> c) describing the application of the software being specified, including relevant benefits, objectives and goals; and
> d) being consistent with similar statements in higher-level specifications (e.g., a system requirements specification), if they exist.

### 1.3 References

> List any other documents or Web addresses to which this SRS refers. These may include user interface style guides, contracts, standards, system requirements specifications, use case documents, or a vision and scope document. Provide enough information so that the reader could access a copy of each reference, including title, author, version number, date, and source or location.

### 1.4 Terms

> Define all the terms necessary to properly interpret the SRS. You may wish to build a separate glossary that spans multiple projects or the entire organization, and just include terms specific to a single project in each SRS.

### 1.5 Abbreviations

> Define abbreviations necessary to properly interpret the SRS.

---

## 2. Product Overview

### 2.1 Product Perspective

> **[IEEE-29148-2018 9.6.4]** Define the system's relationship to other related products. If the product is an element of a larger system, relate the requirements of that larger system to the functionality of the product covered by the SRS.
>
> **[IEEE-29148-2018 9.6.4]** If the product is an element of a larger system, identify the interfaces between the product covered by the SRS and the larger system of which the product is an element.
>
> **[IEEE-29148-2018 9.6.4]** Consider a block diagram showing the major elements of the larger system, interconnections and external interfaces.
>
> **[IEEE-29148-2018 9.6.4]** Describe how the software operates with the following constraints:
>
> a) system interfaces;
> b) user interfaces;
> c) hardware interfaces;
> d) software interfaces;
> e) communications interfaces;
> f) memory;
> g) operations;
> h) site adaptation requirements; and
> i) interfaces with services.

#### 2.1.1 System Interfaces

> **[IEEE-29148-2018 9.6.4.1]** List each system interface and identify the functionality of the software to accomplish the system requirement and the interface description to match the system.

#### 2.1.2 User Interfaces

> **[IEEE-29148-2018 9.6.4.2]** Specify the logical characteristics of each interface between the software product and its users.
>
> **[IEEE-29148-2018 9.6.4.2] NOTE** A style guide for the user interface can provide consistent rules for organization, coding, and interaction of the user with the system.

#### 2.1.3 Hardware Interfaces

> **[IEEE-29148-2018 9.6.4.3]** Specify the logical characteristics of each interface between the software product and the hardware elements of the system. This includes configuration characteristics (number of ports, instruction sets, etc.). It also covers such matters as what devices are to be supported, how they are to be supported, and protocols. For example, terminal support may specify full-screen support as opposed to line-by-line support.

#### 2.1.4 Software Interfaces

> **[IEEE-29148-2018 9.6.4.4]** Specify the use of other required software products (e.g., a data management system, an operating system or a mathematical package), and interfaces with other application systems (e.g., the linkage between an accounts receivable system and a general ledger system).
>
> For each required software product, specify:
>
> a) name;
> b) mnemonic;
> c) specification number;
> d) version number; and
> e) source.
>
> **[IEEE-29148-2018 9.6.4.4] NOTE** It is acceptable to specify required platforms or operating systems, but rarely feasible to require a specific version. Typically, a version number of the most recent version or any currently maintained version can be specified for the software.
>
> **[IEEE-29148-2018 9.6.4.4]** For each interface, specify:
>
> a) discussion of the purpose of the interfacing software as related to this software product;
> b) definition of the interface in terms of message content and format. It is not necessary to detail any well-documented interface, but a reference to the document defining the interfaces is required.

#### 2.1.5 Communication Interfaces

> **[IEEE-29148-2018 9.6.4.5]** Specify the various interfaces to communications such as local network protocols.

#### 2.1.6 Memory Constraints

> **[IEEE-29148-2018 9.6.4.6]** Specify any applicable characteristics and limits on primary and secondary memory.

#### 2.1.7 Operations

> **[IEEE-29148-2018 9.6.4.7]** Specify the normal and special operations required by the user such as:
>
> a) the various modes of operations in the user organization (e.g., user-initiated operations);
> b) periods of interactive operations and periods of unattended operations;
> c) data processing support functions; and
> d) backup and recovery operations.
>
> **[IEEE-29148-2018 9.6.3] NOTE** This is sometimes specified as part of the User Interfaces section.

#### 2.1.8 Site Adaptation Requirements

> **[IEEE-29148-2018 9.6.4.8]** The site adaptation requirements include:
>
> a) definition of the requirements for any data or initialization sequences that are specific to a given site, mission, or operational mode (e.g., grid values, safety limits, etc.);
> b) specification of the site or mission-related features that should be modified to adapt the software to a particular installation.

#### 2.1.9 Interface with Services

> **[IEEE-29148-2018 9.6.4.9]** Specify interactions with services, e.g., Software as a Service (SaaS) or cloud services.

### 2.2 Product Functions

> **[IEEE-29148-2018 9.6.5]** Provide a summary of the major functions that the software will perform, without mentioning the vast amount of detail each of those functions requires. Use cases, user stories and scenarios are also used to describe product functions.
>
> Note that for the sake of clarity:
>
> a) the product functions should be organized in a way that makes the list of functions understandable to the acquirer or to anyone else reading the document for the first time;
> b) textual or graphical methods can be used to show the different functions and their relationships. Such a diagram is not intended to show a design of a product, but simply shows the logical relationships among variables.

### 2.3 User Characteristics

> **[IEEE-29148-2018 9.6.6]** Describe those general characteristics of the intended groups of users of the product including characteristics that may influence usability, such as educational level, experience, disabilities and technical expertise. This description should not state specific requirements, but rather should state the reasons why certain specific requirements are later specified in specific requirements.
>
> **[IEEE-29148-2018 9.6.6] NOTE 1** Where appropriate, the user characteristics of the System Requirements Specification (SyRS) and SRS are consistent.
>
> **[IEEE-29148-2018 9.6.6] NOTE 2** For additional information on context of use and user needs, see ISO/IEC 25063 and ISO/IEC 25064.

### 2.4 Limitations

> **[IEEE-29148-2018 9.6.7]** Provide a general description of any other items that will limit the supplier's options, including:
>
> a) regulatory requirements and policies;
> b) hardware limitations (e.g., signal timing requirements);
> c) interfaces to other applications;
> d) parallel operations;
> e) audit functions;
> f) control functions;
> g) higher-order language requirements;
> h) signal handshake protocols (e.g., XON-XOFF, ACK-NACK);
> i) quality requirements (e.g., reliability);
> j) criticality of the application;
> k) safety and security considerations;
> l) physical/mental considerations; and
> m) limitations that are sourced from other systems, including real-time requirements from the controlled system through interfaces.

### 2.5 Assumptions and Dependencies

> **[IEEE-29148-2018 9.6.8]** List each of the factors that affect the requirements stated in the SRS. These factors are not design constraints on the software but any changes to these factors can affect the requirements in the SRS. For example, an assumption may be that a specific operating system will be available on the hardware designated for the software product. If, in fact, the operating system is not available, the SRS would have to change accordingly.

### 2.6 Apportioning of Requirements

> **[IEEE-29148-2018 9.6.9]** Apportion the software requirements to software elements. For requirements that will require implementation over multiple software elements, or when allocation to a software element is initially undefined, this should be so stated. A cross-reference table by function and software element should be used to summarize the apportionment.
>
> **[IEEE-29148-2018 9.6.9]** Identify requirements that may be delayed until future versions of the system (e.g., blocks and/or increments).

### 2.7 Specified Requirements

> **[IEEE-29148-2018 9.6.10]** Specify the software system requirements to a level of detail sufficient for software design, development and verification of the software increment or release in process. The requirements should:
>
> a) be stated in conformance with all the characteristics described in ISO/IEC/IEEE 29148:2018 Section 5.2;
> b) be cross-referenced to earlier versions or related documents;
> c) be uniquely identifiable;
> d) describe every input (stimulus) into the software system, every output (response) from the software system, and all functions performed by the software system in response to an input or in support of an output.

---

## 3. Specific Requirements

### 3.1 External Interfaces

> **[IEEE-29148-2018 9.6.11]** Define all inputs into and outputs from the software system. The description should complement the interface descriptions in 9.6.4.1 through 9.6.4.5, and should not repeat information there. Each interface defined should include the following content:
>
> a) name of item;
> b) description of purpose;
> c) source of input or destination of output;
> d) valid range, accuracy and/or tolerance;
> e) units of measure;
> f) timing;
> g) relationships to other inputs/outputs;
> h) data formats;
> i) command formats; and
> j) data items or information included in the input and output.

### 3.2 Functions

> **[IEEE-29148-2018 9.6.12]** Define the fundamental actions that have to take place in the software in accepting and processing the inputs and in processing and generating the outputs, including:
>
> a) validity checks on the inputs;
> b) exact sequence of operations;
> c) responses to abnormal situations, including:
>    1) overflow;
>    2) communication facilities;
>    3) hardware faults and failures; and
>    4) error handling and recovery;
> d) effect of parameters;
> e) relationship of outputs to inputs, including:
>    1) input/output sequences; and
>    2) formulas for input to output conversion.
>
> It may be appropriate to partition the functional requirements into sub-functions or sub-processes. This does not imply that the software design will also be partitioned that way.

### 3.3 Usability Requirements

> **[IEEE-29148-2018 9.6.13]** Define usability and quality in use requirements and objectives for the software system that can include measurable effectiveness, efficiency, satisfaction criteria and avoidance of harm that could arise from use in specific contexts of use.
>
> **NOTE** Additional guidance on usability requirements can be found in ISO/IEC TR 25060.

### 3.4 Performance Requirements

> **[IEEE-29148-2018 9.6.14]** Specify both the static and the dynamic numerical requirements placed on the software or on human interaction with the software as a whole.
>
> Static numerical requirements may include the following:
>
> a) the number of terminals to be supported;
> b) the number of simultaneous users to be supported; and
> c) the amount and type of information to be handled.
>
> Static numerical requirements are sometimes identified under a separate section entitled Capacity.
>
> Dynamic numerical requirements may include, for example, the numbers of transactions and tasks and the amount of data to be processed within certain time periods for both normal and peak workload conditions. The performance requirements should be stated in measurable terms.
>
> For example, "95% of the transactions shall be processed in less than 1 s", rather than, "An operator shall not have to wait for the transaction to complete".
>
> **NOTE** Numerical limits applied to one specific function are normally specified as part of the processing subparagraph description of that function.

### 3.5 Logical Database Requirements

> **[IEEE-29148-2018 9.6.15]** Specify the logical requirements for any information that is to be placed into a database, including:
>
> a) types of information used by various functions;
> b) frequency of use;
> c) accessing capabilities;
> d) data entities and their relationships;
> e) integrity constraints;
> f) security; and
> g) data retention requirements.

### 3.6 Design Constraints

> **[IEEE-29148-2018 9.6.16]** Specify constraints on the system design imposed by external standards, regulatory requirements or project limitations.

### 3.7 Standards Compliance

> **[IEEE-29148-2018 9.6.17]** Specify the requirements derived from existing standards or regulations, including:
>
> a) report format;
> b) data naming;
> c) accounting procedures; and
> d) audit tracing.
>
> For example, this could specify the requirement for software to trace processing activity. Such traces are needed for some applications to meet minimum regulatory or financial standards. An audit trace requirement may, for example, state that all changes to a payroll database shall be recorded in a trace file with before and after values.

### 3.8 Software System Attributes

> **[IEEE-29148-2018 9.6.18]** Specify the required attributes of the software product. The following is a partial list of examples:
>
> a) **Reliability** – specify the factors required to establish the required reliability of the software system at the time of delivery.
> b) **Availability** – specify the factors required to guarantee a defined availability level for the entire system such as checkpoint, recovery and restart.
> c) **Security** – specify the requirements to protect the software from accidental or malicious access, use, modification, destruction or disclosure. Specific requirements in this area could include the need to:
>    1) utilize certain cryptographic techniques;
>    2) keep specific log or history data sets;
>    3) assign certain functions to different modules;
>    4) restrict communications between some areas of the program;
>    5) check data integrity for critical variables; and
>    6) assure data privacy.
> d) **Maintainability** – specify attributes of software that relate to the ease of maintenance of the software itself. These may include requirements for certain modularity, interfaces or complexity limitation. Requirements should not be placed here just because they are thought to be good design practices.
> e) **Portability** – specify attributes of software that relate to the ease of porting the software to other host machines and/or operating systems, including:
>    1) percentage of elements with host-dependent code;
>    2) percentage of code that is host dependent;
>    3) use of a proven portable language;
>    4) use of a particular compiler or language subset; and
>    5) use of a particular operating system.

---

## 4. Verification

> **[IEEE-29148-2018 9.6.10]** Provide the verification approaches and methods planned to qualify the software. The information items for verification are recommended to be given in a parallel manner with the information items in 9.6.10 to 9.6.18.

---

## 5. Supporting Information

> **[IEEE-29148-2018 9.6.19]** Additional supporting information to be considered includes:
>
> a) sample input/output formats, descriptions of cost analysis studies or results of user surveys;
> b) supporting or background information that can help the readers of the SRS;
> c) a description of the problems to be solved by the software; and
> d) special packaging instructions for the code and the media to meet security, export, initial loading or other requirements.
>
> The SRS should explicitly state whether or not these information items are to be considered part of the requirements.

<!--
Optional appendix (disabled by default in the original LaTeX template):

## Appendix A. Index
-->