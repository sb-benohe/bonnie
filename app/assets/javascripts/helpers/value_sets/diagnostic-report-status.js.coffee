# Description http://hl7.org/fhir/R4/valueset-diagnostic-report-status.html
@DiagnosticReportStatusValueSet = class DiagnosticReportStatusValueSet
  @JSON = {
    "resourceType" : "ValueSet",
    "id" : "diagnostic-report-status",
    "meta" : {
      "lastUpdated" : "2019-11-01T09:29:23.356+11:00",
      "profile" : ["http://hl7.org/fhir/StructureDefinition/shareablevalueset"]
    },
    "text" : {
      "status" : "generated",
      "div" : "<div xmlns=\"http://www.w3.org/1999/xhtml\"><h2>DiagnosticReportStatus</h2><div><p>The status of the diagnostic report.</p>\n</div><p>This value set includes codes from the following code systems:</p><ul><li>Include all codes defined in <a href=\"codesystem-diagnostic-report-status.html\"><code>http://hl7.org/fhir/diagnostic-report-status</code></a></li></ul></div>"
    },
    "extension" : [{
      "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-wg",
      "valueCode" : "oo"
    },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-standards-status",
        "valueCode" : "trial-use"
      },
      {
        "url" : "http://hl7.org/fhir/StructureDefinition/structuredefinition-fmm",
        "valueInteger" : 3
      }],
    "url" : "http://hl7.org/fhir/ValueSet/diagnostic-report-status",
    "identifier" : [{
      "system" : "urn:ietf:rfc:3986",
      "value" : "urn:oid:2.16.840.1.113883.4.642.3.235"
    }],
    "version" : "4.0.1",
    "name" : "DiagnosticReportStatus",
    "title" : "DiagnosticReportStatus",
    "status" : "draft",
    "experimental" : false,
    "date" : "2019-11-01T09:29:23+11:00",
    "publisher" : "HL7 (FHIR Project)",
    "contact" : [{
      "telecom" : [{
        "system" : "url",
        "value" : "http://hl7.org/fhir"
      },
        {
          "system" : "email",
          "value" : "fhir@lists.hl7.org"
        }]
    }],
    "description" : "The status of the diagnostic report.",
    "immutable" : true,
    "compose" : {
      "include" : [{
        "system" : "http://hl7.org/fhir/diagnostic-report-status",
        "concept" : [{
          "code" : "registered",
          "display" : "Registered",
          "definition" : "The existence of the report is registered, but there is nothing yet available."
        },
          {
            "code" : "partial",
            "display" : "Partial",
            "definition" : "This is a partial (e.g. initial, interim or preliminary) report: data in the report may be incomplete or unverified.",
            "concept" : [{
              "code" : "preliminary",
              "display" : "Preliminary",
              "definition" : "Verified early results are available, but not all  results are final."
            }]
          },
          {
            "code" : "final",
            "display" : "Final",
            "definition" : "The report is complete and verified by an authorized person."
          },
          {
            "code" : "amended",
            "display" : "Amended",
            "definition" : "Subsequent to being final, the report has been modified.  This includes any change in the results, diagnosis, narrative text, or other content of a report that has been issued.",
            "concept" : [{
              "code" : "corrected",
              "display" : "Corrected",
              "definition" : "Subsequent to being final, the report has been modified  to correct an error in the report or referenced results."
            },
              {
                "code" : "appended",
                "display" : "Appended",
                "definition" : "Subsequent to being final, the report has been modified by adding new content. The existing content is unchanged."
              }]
          },
          {
            "code" : "cancelled",
            "display" : "Cancelled",
            "definition" : "The report is unavailable because the measurement was not started or not completed (also sometimes called \"aborted\")."
          },
          {
            "code" : "entered-in-error",
            "display" : "Entered in Error",
            "definition" : "The report has been withdrawn following a previous final release.  This electronic record should never have existed, though it is possible that real-world decisions were based on it. (If real-world activity has occurred, the status should be \"cancelled\" rather than \"entered-in-error\".)."
          },
          {
            "code" : "unknown",
            "display" : "Unknown",
            "definition" : "The authoring/source system does not know which of the status values currently applies for this observation. Note: This concept is not to be used for \"other\" - one of the listed statuses is presumed to apply, but the authoring/source system does not know which."
          }]
      }]
    }
  }