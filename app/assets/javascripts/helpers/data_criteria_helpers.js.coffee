@DataCriteriaHelpers = class DataCriteriaHelpers

  @PRIMARY_TIMING_ATTRIBUTES:
    AdverseEvent: { date: 'dateTime', detected: 'dateTime', recordedDate: 'dateTime' },
    AllergyIntolerance: { recordedDate: 'dateTime', lastOccurrence: 'dateTime' },
    Condition: { recordedDate: 'dateTime' },
    FamilyMemberHistory: { date: 'dateTime' },
    Coverage: { period: 'Period' },
    DiagnosticReport: { issued: 'instant' },
    ImagingStudy: { started: 'DateTime' },
    Observation: { issued: 'instant' },
    Specimen: { receivedTime: 'dateTime' },
    CarePlan: { period: 'Period', created: 'DateTime' },
    CareTeam: { period: 'Period' },
    Goal: { statusDate: 'date' },
    NutritionOrder: { dateTime: 'dateTime' },
    ServiceRequest: { authoredOn: 'dateTime' },
    Claim: { billablePeriod: 'Period', created: 'dateTime' },
    Communication: { sent: 'dateTime', received: 'dateTime' },
    CommunicationRequest: { authoredOn: 'dateTime' },
    DeviceRequest: { authoredOn: 'dateTime' },
    DeviceUseStatement: { recordedOn: 'dateTime' },
    Device: { manufactureDate: 'dateTime', expirationDate: 'dateTime' },
    Encounter: { period: 'Period' },
    Flag: { period: 'Period' },
    Immunization: { recorded: 'dateTime', expirationDate: 'date' },
    ImmunizationEvaluation: { date: 'dateTime' },
    ImmunizationRecommendation: { date: 'dateTime' },
    MedicationDispense: { whenPrepared: 'dateTime', whenHandedOver: 'dateTime' },
    MedicationRequest: { authoredOn: 'dateTime' },
    MedicationStatement: { dateAsserted: 'dateTime' },
    Practitioner: { birthDate: 'date' },
    PractitionerRole: { period: 'Period' },
    RelatedPerson: { period: 'Period', birthDate: 'date' },
    Task: { executionPeriod: 'Period', authoredOn: 'dateTime', lastModified: 'dateTime' }

  @DATA_ELEMENT_CATEGORIES:
    AdverseEvent: 'clinical summary'
    AllergyIntolerance: 'clinical summary'
    Condition: 'clinical summary'
    FamilyMemberHistory: 'clinical summary'
    Procedure: 'clinical summary'

    Coverage: 'financial support'

    BodyStructure: 'diagnostics'
    DiagnosticReport: 'diagnostics'
    ImagingStudy: 'diagnostics'
    Observation: 'diagnostics'
    Specimen: 'diagnostics'

    CarePlan: 'care provision'
    CareTeam: 'care provision'
    Goal: 'care provision'
    NutritionOrder: 'care provision'
    ServiceRequest: 'care provision'

    Claim: 'billing'

    Communication: 'request response'
    CommunicationRequest: 'request response'
    DeviceRequest: 'request response'
    DeviceUseStatement: 'request response'

    Location: 'providers entities'

    Device: 'material entities'
    Substance: 'material entities'

    Encounter: 'management'
    Flag: 'management'

    Immunization: 'medications'
    ImmunizationEvaluation: 'medications'
    ImmunizationRecommendation: 'medications'
    Medication: 'medications'
    MedicationAdministration: 'medications'
    MedicationDispense: 'medications'
    MedicationRequest: 'medications'
    MedicationStatement: 'medications'

    Patient: 'individuals'
    Practitioner: 'individuals'
    PractitionerRole: 'individuals'
    RelatedPerson: 'individuals'

    Task: 'workflow'

  @createIntervalFromPeriod: (period) ->
    return null if period == undefined ||
      (period?.start == undefined && period?.end == undefined)

    startDate = @getCQLDateTimeFromString(period?.start?.value) if period?.start?.value?
    endDate = @getCQLDateTimeFromString(period?.end?.value) if period?.end?.value?
    new cqm.models.CQL.Interval(startDate, endDate)

  @getCQLDateTimeFromString: (dateStr) ->
    return null if dateStr == undefined
    cqm.models.CQL.DateTime.fromJSDate(new Date(dateStr), 0)

  @getCQLDateFromString: (dateStr) ->
    return null if dateStr == undefined
    cqm.models.CQL.Date.fromJSDate(new Date(dateStr))

  @createPeriodFromInterval: (interval) ->
    period = new cqm.models.Period()
    period.start = period.end = null
    period.start = cqm.models.PrimitiveDateTime.parsePrimitive interval.low.toString() if interval && interval.low?
    period.end = cqm.models.PrimitiveDateTime.parsePrimitive interval.high.toString() if interval && interval.high?
    return period

  @getPeriodForStringDateTime: (dateTimeStr) ->
    return null unless dateTimeStr?
    cqlDateTime = @getCQLDateTimeFromString(dateTimeStr)
    interval = new cqm.models.CQL.Interval(cqlDateTime, cqlDateTime.add(15, cqm.models.CQL.DateTime.Unit.MINUTE))
    @createPeriodFromInterval(interval)

  @getPeriodForStringDate: (dateTimeStr) ->
    return null unless dateTimeStr?
    cqlDateTime = @getCQLDateTimeFromString(dateTimeStr).add(8, cqm.models.CQL.DateTime.Unit.HOUR)
    interval = new cqm.models.CQL.Interval(cqlDateTime, cqlDateTime.add(15, cqm.models.CQL.DateTime.Unit.MINUTE))
    @createPeriodFromInterval(interval)

  @getPrimitiveDateTimeForCqlDateTime: (dateTime) ->
    cqm.models.PrimitiveDateTime.parsePrimitive dateTime?.toString()

  @getPrimitiveDateTimeForStringDateTime: (dateTimeStr) ->
    cqm.models.PrimitiveDateTime.parsePrimitive dateTimeStr

  @getPrimitiveDateTimeForStringDate: (dateStr) ->
    return null unless dateStr?
    cqlDateTime = @getCQLDateTimeFromString(dateStr).add(8, cqm.models.CQL.DateTime.Unit.HOUR)
    cqm.models.PrimitiveDateTime.parsePrimitive cqlDateTime.toString()

  @getPrimitiveInstantForCqlDateTime: (dateTime) ->
    cqm.models.PrimitiveInstant.parsePrimitive dateTime?.toString()

  @getPrimitiveDateForCqlDate: (date) ->
    cqm.models.PrimitiveDate.parsePrimitive date?.toString()

  @getPrimitiveDateForStringDateTime: (dateTimeStr) ->
    return null unless dateTimeStr?
    cqlDate = @getCQLDateFromString(dateTimeStr)
    cqm.models.PrimitiveDate.parsePrimitive cqlDate.toString()

  @getPrimaryCodePath: (dataElement) ->
    return cqm.models[dataElement.fhir_resource?.constructor?.name]?.primaryCodePath

  @getPrimaryCodes: (dataElement) ->
    return dataElement?.fhir_resource?.primaryCode?.coding || []

  @setPrimaryCodes: (dataElement, codes) ->
    codeableConcept = new cqm.models.CodeableConcept()
    codeableConcept.coding = codes
    dataElement?.fhir_resource?.primaryCode = codeableConcept

  @getAttributes: (dataElement) ->
    resourceType = dataElement.fhir_resource?.resourceType
    attributes = @DATA_ELEMENT_ATTRIBUTES[resourceType]
    return attributes || []

  @getAttribute: (dataElement, path) ->
    resourceType = dataElement.fhir_resource?.resourceType
    return @DATA_ELEMENT_ATTRIBUTES[resourceType]?.find((attr) => attr.path is path)

# Data element attributes per resource type.
# Each resource has an array of entries per attribute.
# An attribute entry has necessary metadata to view/edit.
#   path - attribute/element path, relative to the current resource
#   title - an element name show to the User, same as path for now
#   getValue(fhirResource) - getter accessor which returns a FHIR value for the attribute,
#      shall be compatible with an UI element
#   setValue(fhirResource, value) - setter accessor which updates the resource with a value from UI.
#      shall be compatible with an UI element
#   types - an array of types. A simple attribute would have just one type entry. A choice type would have multiple type entries.
#       The user will be shown a type name on the UI to choose and its used to create a right UI editor element.
#       See DataCriteriaAttributeEditorView._createInputViewForType
#   valueSets - optional value sets for bindings
  @DATA_ELEMENT_ATTRIBUTES:
    AdverseEvent: []
    AllergyIntolerance: [
      {
        path: 'clinicalStatus'
        title: 'clinicalStatus'
        getValue: (fhirResource) => fhirResource?.clinicalStatus?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource.clinicalStatus = null
          else
            fhirResource.clinicalStatus = new cqm.models.CodeableConcept()
            fhirResource.clinicalStatus.coding = [coding]
        types: [
          'CodeableConcept'
        ]
        valueSets: () -> [FhirValueSets.ALLERGYINTOLERANCE_CLINICAL_VS]
      },
      {
        path: 'onset'
        title: 'onset'
        getValue: (fhirResource) => fhirResource?.onset
        setValue: (fhirResource, value) =>
          attrType = value?.constructor?.name
          if attrType == 'DateTime'
            fhirResource.onset = @getPrimitiveDateTimeForCqlDateTime(value)
          else if attrType == 'Age' || attrType == 'Period' || attrType == 'Range'
            fhirResource.onset = value
          else
            fhirResource.onset = null
        types: ['DateTime', 'Age', 'Period', 'Range']
      },
      {
        path: 'verificationStatus',
        title: 'verificationStatus',
        getValue: (fhirResource) => fhirResource?.verificationStatus?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource.verificationStatus = null
          else
            fhirResource.verificationStatus = new cqm.models.CodeableConcept()
            fhirResource.verificationStatus.coding = [coding]
        types: [
          'CodeableConcept'
        ],
        valueSets: () -> [FhirValueSets.ALLERGYINTOLERANCE_VERIFICATION_VS]
      }
    ]
    Condition: [
      {
        path: 'clinicalStatus'
        title: 'clinicalStatus'
        getValue: (fhirResource) => fhirResource?.clinicalStatus?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource.clinicalStatus = null
          else
            fhirResource.clinicalStatus = new cqm.models.CodeableConcept()
            fhirResource.clinicalStatus.coding = [coding]
        types: [
          'CodeableConcept'
        ]
        valueSets: () -> [FhirValueSets.CONDITION_CLINICAL_VS]
      },
      {
        path: 'verificationStatus',
        title: 'verificationStatus',
        getValue: (fhirResource) => fhirResource?.verificationStatus?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource.verificationStatus = null
          else
            fhirResource.verificationStatus = new cqm.models.CodeableConcept()
            fhirResource.verificationStatus.coding = [coding]
        types: [
          'CodeableConcept'
        ],
        valueSets: () -> [FhirValueSets.CONDITION_VER_STATUS_VS]
      },
      {
        path: 'onset'
        title: 'onset'
        getValue: (fhirResource) => fhirResource?.onset
        setValue: (fhirResource, value) =>
          attrType = value?.constructor?.name
          if attrType == 'DateTime'
            fhirResource.onset = @getPrimitiveDateTimeForCqlDateTime(value)
          else if attrType == 'Age' || attrType == 'Period' || attrType == 'Range'
            fhirResource.onset = value
          else
            fhirResource.onset = null
        types: ['DateTime', 'Age', 'Period', 'Range']
      },
      {
        path: 'abatement',
        title: 'abatement',
        getValue: (fhirResource) => fhirResource?.abatement
        setValue: (fhirResource, value) =>
          attrType = value?.constructor?.name
          if attrType == 'DateTime'
            fhirResource.abatement = @getPrimitiveDateTimeForCqlDateTime(value)
          else if attrType == 'Age' ||  attrType == 'Period' || attrType == 'Range'
            fhirResource.abatement = value
          else
            fhirResource.abatement = null
        types: ['DateTime', 'Age', 'Period', 'Range']
      },
      {
        path: 'bodySite',
        title: 'bodySite',
        getValue: (fhirResource) => fhirResource?.bodySite?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource.bodySite = null
          else
            codeableConcept = new cqm.models.CodeableConcept()
            codeableConcept.coding = [coding]
            fhirResource.bodySite = [ codeableConcept ]
        types: [
          'CodeableConcept'
        ],
        valueSets: () -> [FhirValueSets.BODY_SITE_VS]
      },
      {
        path: 'category',
        title: 'category',
        getValue: (fhirResource) => fhirResource?.category?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource.category = null
          else
            codeableConcept = new cqm.models.CodeableConcept()
            codeableConcept.coding = [coding]
            fhirResource.category = [ codeableConcept ]
        types: [
          'CodeableConcept'
        ],
        valueSets: () -> [FhirValueSets.CONDITION_CATEGORY_VS]
      }
    ]
    FamilyMemberHistory: []
    Procedure: [
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) => fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if codeValue?
            fhirResource?.status = cqm.models.ProcedureStatus.parsePrimitive(codeValue)
          else
            fhirResource?.status = null
        types: ['Code']
        valueSets: () => [FhirValueSets.EVENT_STATUS_VS]
      },
      {
        path: 'performed',
        title: 'performed',
        getValue: (fhirResource) => fhirResource?.performed
        setValue: (fhirResource, value) =>
          attrType = value?.constructor?.name
          if attrType == 'DateTime'
            fhirResource.performed = @getPrimitiveDateTimeForCqlDateTime(value)
          else if attrType == 'Period'
            fhirResource.performed = value
          else
            fhirResource.performed = null
        types: ['DateTime', 'Period']
      },
      {
        path: 'category',
        title: 'category',
        getValue: (fhirResource) => fhirResource?.category?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource.category = null
          else
            fhirResource.category = new cqm.models.CodeableConcept()
            fhirResource.category.coding = [coding]
        types: ['CodeableConcept'],
        valueSets: () -> [FhirValueSets.PROCEDURE_CATEGORY_VS]
      },
      {
        path: 'statusReason',
        title: 'statusReason',
        getValue: (fhirResource) => fhirResource?.statusReason?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource.statusReason = null
          else
            fhirResource.statusReason = new cqm.models.CodeableConcept()
            fhirResource.statusReason.coding = [coding]
        types: ['CodeableConcept'],
        valueSets: () -> [FhirValueSets.PROCEDURE_NOT_PERFORMED_REASON_VS]
      },
      {
        path: 'usedCode',
        title: 'usedCode',
        getValue: (fhirResource) => fhirResource?.usedCode?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource.usedCode = null
          else
            codeableConcept = new cqm.models.CodeableConcept()
            codeableConcept.coding = [coding]
            fhirResource.usedCode = [codeableConcept]
        types: ['CodeableConcept'],
        valueSets: () -> [FhirValueSets.DEVICE_KIND_VS]
      }
    ]
    Coverage: []
    BodyStructure: []
    DiagnosticReport: []
    ImagingStudy: []
    Observation: []
    Specimen: []
    CarePlan: []
    CareTeam: []
    Goal: []
    NutritionOrder: []
    ServiceRequest: [
      {
        path: 'intent'
        title: 'intent'
        getValue: (fhirResource) => fhirResource?.intent?.value
        setValue: (fhirResource, codeValue) =>
          if (codeValue)
            fhirResource?.intent = cqm.models.ServiceRequestIntent.parsePrimitive(codeValue)
          else
            fhirResource?.intent = null
        types: ['Code']
        valueSets: () => [FhirValueSets.REQUEST_INTENT]
      },
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) => fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if (codeValue)
            fhirResource?.status = cqm.models.ServiceRequestStatus.parsePrimitive(codeValue)
          else
            fhirResource?.status = null
        types: ['Code']
        valueSets: () => [FhirValueSets.REQUEST_STATUS]
      }
    ]
    Claim: []
    Communication: []
    CommunicationRequest: []
    DeviceRequest: []
    DeviceUseStatement: []
    Location: []
    Device: []
    Substance: []
    Encounter: [
      {
        path: 'class'
        title: 'class'
        getValue: (fhirResource) => fhirResource?['class']
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource?['class'] = null
          else
            fhirResource?['class'] = coding
        types: ['Coding']
        valueSets: () => [FhirValueSets.ACT_ENCOUNTER_CODE_VS]
      },
      {
        path: 'length'
        title: 'length'
        getValue: (fhirResource) =>
          fhirResource?.length
        setValue: (fhirResource, value) =>
          fhirResource?.length = value
        types: ['Duration']
      },
      {
        path: 'location.period'
        title: 'location.period'
        getValue: (fhirResource) =>
          fhirResource?.location?[0]?.period
        setValue: (fhirResource, value) =>
          if !fhirResource.location
            encounterLocation = new cqm.models.EncounterLocation()
            fhirResource.location = [encounterLocation]
          fhirResource.location[0].period = value
        types: ['Period']
      },
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) =>
          return fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if !codeValue?
            fhirResource?.status = null
          else
            fhirResource?.status = cqm.models.EncounterStatus.parsePrimitive(codeValue)
        types: ['Code']
        valueSets: () =>
          FhirValueSets.ENCOUNTER_STATUS_VS
      },
      {
        path: 'hospitalization.admitSource',
        title: 'hospitalization.admitSource',
        getValue: (fhirResource) => fhirResource?.hospitalization?.admitSource?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !fhirResource.hospitalization
            hospitalization = new cqm.models.EncounterHospitalization()
            fhirResource.hospitalization = hospitalization
          if !coding?
            fhirResource.hospitalization.admitSource = null
          else
            fhirResource.hospitalization.admitSource = new cqm.models.CodeableConcept()
            fhirResource.hospitalization.admitSource.coding = [coding]
        types: ['CodeableConcept']
        valueSets: () -> [FhirValueSets.ENCOUNTER_ADMIT_SOURCE_VS]
      },
      {
        path: 'hospitalization.dischargeDisposition',
        title: 'hospitalization.dischargeDisposition',
        getValue: (fhirResource) =>
          return fhirResource?.hospitalization?.dischargeDisposition?.coding?[0]
        setValue: (fhirResource, coding) =>
          # EncounterHospitalization
          if !fhirResource.hospitalization
            hospitalization = new cqm.models.EncounterHospitalization()
            fhirResource.hospitalization = hospitalization
          if !coding?
            fhirResource.hospitalization.dischargeDisposition = null
          else
            fhirResource.hospitalization.dischargeDisposition = new cqm.models.CodeableConcept()
            fhirResource.hospitalization.dischargeDisposition.coding = [coding]
        types: [
          'CodeableConcept' # User will see 'CodeableConcept', but it works with Coding behind the scenes
        ]
        valueSets: () =>
          FhirValueSets.DISCHARGE_DISPOSITION_VS
      },
    ]
    Flag: []
    Immunization: []
    ImmunizationEvaluation: []
    ImmunizationRecommendation: []
    Medication: []
    MedicationAdministration: [
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) => fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if !codeValue?
            fhirResource?.status = null
          else
            fhirResource?.status = cqm.models.MedicationAdministrationStatus.parsePrimitive(codeValue)
        types: ['Code']
        valueSets: () => [FhirValueSets.MEDICATION_ADMIN_STATUS_VS]
      },
      {
        path: 'statusReason'
        title: 'statusReason'
        getValue: (fhirResource) => fhirResource?.statusReason?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource.statusReason = null
          else
            fhirResource.statusReason = [new cqm.models.CodeableConcept()]
            fhirResource.statusReason[0].coding = [coding]
        types: ['CodeableConcept']
        valueSets: () -> [FhirValueSets.REASON_MEDICATION_NOT_GIVEN_VS]
      },
      {
        path: 'dosage.route',
        title: 'dosage.route',
        getValue: (fhirResource) =>
          return fhirResource?.dosage?.route?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !fhirResource.MedicationAdministrationDosage
            fhirResource.dosage = new cqm.models.MedicationAdministrationDosage()
          if !coding?
            fhirResource.dosage.route = null
          else
            fhirResource.dosage.route = new cqm.models.CodeableConcept()
            fhirResource.dosage.route.coding = [coding]
        types: ['CodeableConcept']
        valueSets: () => [FhirValueSets.ROUTE_CODES_VS]
      },
#      {
#        path: 'dosage.rate',
#        title: 'dosage.rate',
#        getValue: (fhirResource) =>
#          return fhirResource?.dosage?.rate
#        setValue: (fhirResource, value) =>
#          if !fhirResource.MedicationAdministrationDosage
#            fhirResource.dosage = new cqm.models.MedicationAdministrationDosage()
#          if !value?
#            fhirResource.dosage.rate = null
#          else
#            fhirResource.dosage.rate = value
#        types: ['Ratio']
#      },
      {
        path: 'reasonCode',
        title: 'reasonCode',
        getValue: (fhirResource) => fhirResource?.reasonCode?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource.reasonCode = null
          else
            fhirResource.reasonCode = [new cqm.models.CodeableConcept()]
            fhirResource.reasonCode[0].coding = [coding]
        types: ['CodeableConcept']
        valueSets: () -> [FhirValueSets.REASON_MEDICATION_GIVEN_VS]
      },
    ]
    MedicationDispense: []
    MedicationRequest: [
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) => fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if !codeValue?
            fhirResource?.status = null
          else
            fhirResource?.status = cqm.models.MedicationRequestStatus.parsePrimitive(codeValue)
        types: ['Code']
        valueSets: () => [FhirValueSets.MEDICATION_REQUEST_STATUS_VS]
      },
      {
        path: 'intent'
        title: 'intent'
        getValue: (fhirResource) => fhirResource?.intent?.value
        setValue: (fhirResource, codeValue) =>
          if !codeValue?
            fhirResource?.intent = null
          else
            fhirResource?.intent = cqm.models.MedicationRequestIntent.parsePrimitive(codeValue)
        types: ['Code']
        valueSets: () => [FhirValueSets.MEDICATION_REQUEST_INTENT_VS]
      },
      {
        path: 'category'
        title: 'category'
        getValue: (fhirResource) => fhirResource?.category?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource.category = null
          else
            fhirResource.category = [new cqm.models.CodeableConcept()]
            fhirResource.category[0].coding = [ coding ]
        types: ['CodeableConcept']
        valueSets: () -> [FhirValueSets.MEDICATION_REQUEST_CATEGORY_VS]
      },
      {
        path: 'dispenseRequest.validityPeriod'
        title: 'dispenseRequest.validityPeriod'
        getValue: (fhirResource) => fhirResource?.dispenseRequest?.validityPeriod
        setValue: (fhirResource, period) =>
          if !period?
            fhirResource?.dispenseRequest?.validityPeriod = null
          else
            fhirResource.dispenseRequest = new cqm.models.MedicationRequestDispenseRequest() unless fhirResource?.dispenseRequest
            fhirResource.dispenseRequest.validityPeriod = period
        types: ['Period']
      },
      {
        path: 'dosageInstruction.doseAndRate.rate'
        title: 'dosageInstruction.doseAndRate.rate'
        getValue: (fhirResource) =>
          if  cqm.models.SimpleQuantity.isSimpleQuantity(fhirResource?.dosageInstruction?[0]?.doseAndRate?[0]?.rate)
            # Widget supports only Quantity:  convert SimpleQuantity -> Quantity
            return cqm.models.Quantity.parse(fhirResource?.dosageInstruction?[0]?.doseAndRate?[0]?.rate.toJSON())
          else
            return fhirResource?.dosageInstruction?[0]?.doseAndRate?[0]?.rate
        setValue: (fhirResource, rate) =>
          if !rate?
            fhirResource?.dosageInstruction?[0]?.doseAndRate?[0]?.rate = null
          else
            fhirResource.dosageInstruction = [ new cqm.models.Dosage() ] unless fhirResource?.dosageInstruction
            fhirResource.dosageInstruction[0].doseAndRate = [ new cqm.models.DosageDoseAndRate() ] unless fhirResource?.dosageInstruction?[0]?.doseAndRate
            if cqm.models.Quantity.isQuantity(rate)
              # Widget supports only Quantity: convert Quantity -> SimpleQuantity
              fhirResource.dosageInstruction[0].doseAndRate[0].rate = cqm.models.SimpleQuantity.parse(rate.toJSON())
            else
              fhirResource.dosageInstruction[0].doseAndRate[0].rate = rate
        types: ['Ratio', 'Range', 'SimpleQuantity']
      },
      {
        path: 'dosageInstruction.timing.code'
        title: 'dosageInstruction.timing.code'
        getValue: (fhirResource) => fhirResource?.dosageInstruction?[0]?.timing?.code?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource?.dosageInstruction?[0]?.timing?.code = null
          else
            fhirResource.dosageInstruction = [ new cqm.models.Dosage() ] unless fhirResource?.dosageInstruction
            fhirResource.dosageInstruction[0].timing = new cqm.models.Timing() unless fhirResource?.dosageInstruction?[0]?.timing
            fhirResource.dosageInstruction[0].timing.code = new cqm.models.CodeableConcept()
            fhirResource.dosageInstruction[0].timing.code.coding = [ coding ]

        valueSets: () ->
          [FhirValueSets.TIMING_ABBREVIATION_VS]
        types: ['CodeableConcept']
      },
      {
        path: 'dosageInstructions.timing.repeat.bounds'
        title: 'dosageInstructions.timing.repeat.bounds'
        getValue: (fhirResource) => fhirResource?.dosageInstruction?[0]?.timing?.repeat?.bounds
        setValue: (fhirResource, bounds) =>
          if !bounds?
            fhirResource?.dosageInstruction?[0]?.timing?.repeat?.bounds = null
          else
            fhirResource.dosageInstruction = [ new cqm.models.Dosage() ] unless fhirResource?.dosageInstruction
            fhirResource.dosageInstruction[0].timing = new cqm.models.Timing() unless fhirResource?.dosageInstruction?[0]?.timing
            fhirResource.dosageInstruction[0].timing.repeat = new cqm.models.TimingRepeat() unless fhirResource?.dosageInstruction?[0]?.timing?.repeat
            fhirResource.dosageInstruction[0].timing.repeat.bounds = bounds
        types: ['Duration', 'Range', 'Period']
      },
      {
        path: 'reasonCode'
        title: 'reasonCode'
        getValue: (fhirResource) => fhirResource?.reasonCode?[0]?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource?.reasonCode = null
          else
            codeableConcept = new cqm.models.CodeableConcept()
            codeableConcept.coding = [ coding ]
            fhirResource?.reasonCode = [ codeableConcept ]
        valueSets: () -> [FhirValueSets.CONDITION_CODES_VS]
        types: ['CodeableConcept']
      },
      {
        path: 'statusReason'
        title: 'statusReason'
        getValue: (fhirResource) => fhirResource?.statusReason?.coding?[0]
        setValue: (fhirResource, coding) =>
          if !coding?
            fhirResource?.statusReason = null
          else
            codeableConcept = new cqm.models.CodeableConcept()
            codeableConcept.coding = [ coding ]
            fhirResource?.statusReason = codeableConcept
        valueSets: () -> [FhirValueSets.MEDICATION_REQUEST_STATUS_REASON_VS]
        types: ['CodeableConcept']
      }
    ]
    MedicationStatement: [
      {
        path: 'status'
        title: 'status'
        getValue: (fhirResource) => fhirResource?.status?.value
        setValue: (fhirResource, codeValue) =>
          if !codeValue?
            fhirResource?.status = null
          else
            fhirResource?.status = cqm.models.MedicationStatementStatus.parsePrimitive(codeValue)
        types: ['Code']
        valueSets: () => [FhirValueSets.MEDICATION_STATEMENT_STATUS_VS]
      }
    ]
    Patient: []
    Practitioner: []
    PractitionerRole: []
    RelatedPerson: []
    Task: []