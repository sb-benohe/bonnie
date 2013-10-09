class PatientsController < ApplicationController
	before_filter :authenticate_user!
	# before_filter :validate_authorization!

  JAN_ONE_THREE_THOUSAND=32503698000000
  RACE_NAME_MAP={'1002-5' => 'American Indian or Alaska Native','2028-9' => 'Asian','2054-5' => 'Black or African American','2076-8' => 'Native Hawaiian or Other Pacific Islander','2106-3' => 'White','2131-1' => 'Other'}
  ETHNICITY_NAME_MAP={'2186-5'=>'Not Hispanic or Latino', '2135-2'=>'Hispanic Or Latino'}

  def index

    # if we want to show patients for a given measure id
    if(params.include? :mid)

      # grab the measure and reset the patients list
      @measure = Measure.find(params[:mid])
      @patients = []

      begin
        @patients = PatientHelper.get_patients_by_measure_hqmf_and_nqf(@measure)
      rescue Mongoid::Errors::DocumentNotFound, Mongoid::Errors::InvalidFind
        @patients = []
      end

      flash.now[:info] = "Showing patients for Measure [ " + @measure.hqmf_id.to_s() + " : " + @measure.title.to_s() + " : " + @measure.measure_id + " ]!"

    else
      @patients = Record.asc(:id)
    end
    
  end

  def show
    @patient = Record.find(params[:id])
  end

  def edit
  end

  def save

    #@measure = current_user.measures.where('_id' => params[:id]).exists? ? current_user.measures.find(params[:id]) : current_user.measures.where('measure_id' => params[:id]).first
    # Using just a random Measure entry until users are associated with measures...
    @measure = Measure.skip(rand(Measure.count)).first

    patient = Record.where({'_id' => params['record_id']}).first || HQMF::Generator.create_base_patient(params.select{|k| ['first', 'last', 'gender', 'expired', 'birthdate'].include? k })

    if (params['clone'])
      patient = Record.new(patient.attributes.except('_id'));
      patient.save!
    end

    patient['measure_ids'] ||= []
    patient['measure_ids'] = Array.new(patient['measure_ids']).push(@measure['measure_id']) unless patient['measure_ids'].include? @measure['measure_id']

    patient['birthdate'] = Time.parse(params['birthdate']).to_i

    ['first', 'last', 'gender', 'expired', 'birthdate', 'description', 'description_category'].each {|param| patient[param] = params[param]}
    patient['ethnicity'] = {'code' => params['ethnicity'], 'name'=>ETHNICITY_NAME_MAP[params['ethnicity']], 'codeSystem' => 'CDC Race'}
    patient['race'] = {'code' => params['race'], 'name'=>RACE_NAME_MAP[params['race']], 'codeSystem' => 'CDC Race'}

    measure_period = {'id' => 'MeasurePeriod', 'start_date' => params['measure_period_start'].to_i, 'end_date' => params['measure_period_end'].to_i}
    patient['source_data_criteria'] = JSON.parse(params['data_criteria']) + [measure_period]
    patient['measure_period_start'] = measure_period['start_date']
    patient['measure_period_end'] = measure_period['end_date']

    insurance_types = {
      'MA' => 'Medicare',
      'MC' => 'Medicaid',
      'OT' => 'Other'
    }

    insurance_codes = {
      'MA' => '1',
      'MC' => '2',
      'OT' => '349'
    }

    insurance_provider = InsuranceProvider.new
    insurance_provider.type = params['payer']
    insurance_provider.member_id = '1234567890'
    insurance_provider.name = insurance_types[params['payer']]
    insurance_provider.financial_responsibility_type = {'code' => 'SELF', 'codeSystem' => 'HL7 Relationship Code'}
    insurance_provider.start_time = Time.new(2008,1,1).to_i
    insurance_provider.payer = Organization.new
    insurance_provider.payer.name = insurance_provider.name
    insurance_provider.codes["SOP"] = [insurance_codes[params['payer']]]
    patient.insurance_providers = [insurance_provider]

    Measures::PatientBuilder.rebuild_patient(patient)

    if @measure.records.include? patient
      render :json => patient.save!
    else
      @measure.records.push(patient)
      render :json => @measure.save!
    end
    
  end

  def download
  end

  def destroy
  end

  def validate_authorization!
  end

  def new
    @patient = HQMF::Generator.create_base_patient
  end

  def create_test
    @patient = HQMF::Generator.create_base_patient

    @measure = Measure.skip(rand(Measure.count)).first
    @patient.measure_id = @measure.hqmf_id
    if @patient.measure_ids.nil?
      @patient.measure_ids = []
    end
    @patient.measure_ids << @measure.measure_id

    if @patient.save!
      flash[:success] = "Test patient [ " + @patient.id.to_s() + " : " + @patient.last.to_s() + ", " + @patient.first.to_s() + " ] was created and saved!"
    else
      flash[:error] = "Failed to save test patient!"
    end
    redirect_to patients_path
  end

end