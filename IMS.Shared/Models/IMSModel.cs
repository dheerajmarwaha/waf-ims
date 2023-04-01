//CAUTION: THIS IS AN AUTO GENERATED FILE. DON'T ALTER THE COTENTS.
//USE BREEZE TO REGENERATE THIS FILE IF THERE ARE CHANGES IN THE SCHEMA.
//ALL CLASSES IN THIS FILE ARE PARTIAL, YOU MAY WANT TO EITHER EXTEND PARTIAL CLASS IN ANOTHER FILE OR INHERIT FROM THESE CLASSES
using System;
using System.ComponentModel.DataAnnotations;
using WAF.Shared.Models;
using System.ComponentModel;
using Newtonsoft.Json;
using WAF.Shared.Utils;
using System.Collections.Generic;
using WAF.Shared.Extensions;
namespace IMS.Shared.Models{
	public partial class Department : BaseEntity	{
		public Department() { }
		public Department(PropertyChangedEventHandler propertyChangedHandler) { this.PropertyChanged += propertyChangedHandler; }
		#region Backing fields for all properties
		System.Int32? _id;
		System.String _dept;
		System.Int32? _emp_id;
		public override void SetBooleansToFalse() 		{
		}
		#endregion

		public virtual System.Int32? id		{
			get			{
				return _id;
			}
			set			{
				if (_id != value)				{
					_id = value;
					this.OnPropertyChanged();
				}
			}
		}


		[MaxLength(50)]
		public virtual System.String dept		{
			get			{
				return _dept;
			}
			set			{
				if (_dept != value)				{
					_dept = value;
					this.OnPropertyChanged();
				}
			}
		}


		public virtual System.Int32? emp_id		{
			get			{
				return _emp_id;
			}
			set			{
				if (_emp_id != value)				{
					_emp_id = value;
					this.OnPropertyChanged();
				}
			}
		}


		public override string Id { get { return Convert.ToString(id); }  }

	}
	public partial class Owner : BaseEntity	{
		public Owner() { }
		public Owner(PropertyChangedEventHandler propertyChangedHandler) { this.PropertyChanged += propertyChangedHandler; }
		#region Backing fields for all properties
		System.Int32? _owner_id;
		System.String _owner_nm;
		System.String _contact_number;
		System.String _email_id;
		System.String _address_line;
		System.Int32? _state_id;
		System.String _pincode;
		System.DateTime? _last_refresh_dtm;
		public override void SetBooleansToFalse() 		{
		}
		#endregion

		public virtual System.Int32? owner_id		{
			get			{
				return _owner_id;
			}
			set			{
				if (_owner_id != value)				{
					_owner_id = value;
					this.OnPropertyChanged();
				}
			}
		}


		[MaxLength(50)]
		public virtual System.String owner_nm		{
			get			{
				return _owner_nm;
			}
			set			{
				if (_owner_nm != value)				{
					_owner_nm = value;
					this.OnPropertyChanged();
				}
			}
		}


		[MaxLength(11)]
		public virtual System.String contact_number		{
			get			{
				return _contact_number;
			}
			set			{
				if (_contact_number != value)				{
					_contact_number = value;
					this.OnPropertyChanged();
				}
			}
		}


		[MaxLength(100)]
		public virtual System.String email_id		{
			get			{
				return _email_id;
			}
			set			{
				if (_email_id != value)				{
					_email_id = value;
					this.OnPropertyChanged();
				}
			}
		}


		[MaxLength(500)]
		public virtual System.String address_line		{
			get			{
				return _address_line;
			}
			set			{
				if (_address_line != value)				{
					_address_line = value;
					this.OnPropertyChanged();
				}
			}
		}


		public virtual System.Int32? state_id		{
			get			{
				return _state_id;
			}
			set			{
				if (_state_id != value)				{
					_state_id = value;
					this.OnPropertyChanged();
				}
			}
		}


		[MaxLength(6)]
		public virtual System.String pincode		{
			get			{
				return _pincode;
			}
			set			{
				if (_pincode != value)				{
					_pincode = value;
					this.OnPropertyChanged();
				}
			}
		}


		public virtual System.DateTime? last_refresh_dtm		{
			get			{
				return _last_refresh_dtm;
			}
			set			{
				if (_last_refresh_dtm != value)				{
					_last_refresh_dtm = value;
					this.OnPropertyChanged();
				}
			}
		}


		public override string Id { get { return Convert.ToString(owner_id); }  }

		public override string Display { get { return Convert.ToString(owner_nm); }  }
	}
	public partial class Program : BaseEntity	{
		public Program() { }
		public Program(PropertyChangedEventHandler propertyChangedHandler) { this.PropertyChanged += propertyChangedHandler; }
		#region Backing fields for all properties
		System.Int32? _program_id;
		System.String _program_code;
		System.String _program_nm;
		System.DateTime? _from_date;
		System.DateTime? _till_date;
		System.Int32? _is_active;
		System.Int32? _is_frozen;
		System.Int32? _district_or_city_id;
		System.String _location_nm;
		System.String _remarks;
		public override void SetBooleansToFalse() 		{
		}
		#endregion

		public virtual System.Int32? program_id		{
			get			{
				return _program_id;
			}
			set			{
				if (_program_id != value)				{
					_program_id = value;
					this.OnPropertyChanged();
				}
			}
		}


		[MaxLength(5)]
		public virtual System.String program_code		{
			get			{
				return _program_code;
			}
			set			{
				if (_program_code != value)				{
					_program_code = value;
					this.OnPropertyChanged();
				}
			}
		}


		[MaxLength(50)]
		public virtual System.String program_nm		{
			get			{
				return _program_nm;
			}
			set			{
				if (_program_nm != value)				{
					_program_nm = value;
					this.OnPropertyChanged();
				}
			}
		}


		public virtual System.DateTime? from_date		{
			get			{
				return _from_date;
			}
			set			{
				if (_from_date != value)				{
					_from_date = value;
					this.OnPropertyChanged();
				}
			}
		}


		public virtual System.DateTime? till_date		{
			get			{
				return _till_date;
			}
			set			{
				if (_till_date != value)				{
					_till_date = value;
					this.OnPropertyChanged();
				}
			}
		}


		public virtual System.Int32? is_active		{
			get			{
				return _is_active;
			}
			set			{
				if (_is_active != value)				{
					_is_active = value;
					this.OnPropertyChanged();
				}
			}
		}


		public virtual System.Int32? is_frozen		{
			get			{
				return _is_frozen;
			}
			set			{
				if (_is_frozen != value)				{
					_is_frozen = value;
					this.OnPropertyChanged();
				}
			}
		}


		public virtual System.Int32? district_or_city_id		{
			get			{
				return _district_or_city_id;
			}
			set			{
				if (_district_or_city_id != value)				{
					_district_or_city_id = value;
					this.OnPropertyChanged();
				}
			}
		}


		[MaxLength(100)]
		public virtual System.String location_nm		{
			get			{
				return _location_nm;
			}
			set			{
				if (_location_nm != value)				{
					_location_nm = value;
					this.OnPropertyChanged();
				}
			}
		}


		[MaxLength(500)]
		public virtual System.String remarks		{
			get			{
				return _remarks;
			}
			set			{
				if (_remarks != value)				{
					_remarks = value;
					this.OnPropertyChanged();
				}
			}
		}


		public override string Id { get { return Convert.ToString(program_id); }  }

		public override string Display { get { return Convert.ToString(program_nm); }  }
	}
	public partial class Inventory : BaseEntity	{
		public Inventory() { }
		public Inventory(PropertyChangedEventHandler propertyChangedHandler) { this.PropertyChanged += propertyChangedHandler; }
		#region Backing fields for all properties
		System.Int64? _inventory_id;
		Lookup _owner_id_lookup;
		System.String _make;
		System.String _serial_no;
		System.DateTime? _in_date;
		System.DateTime? _out_date;
		System.Int32? _is_deparment_item;
		System.Int32? _total_parts_count;
		System.String _remarks;
		Lookup _program_id_lookup;
		public override void SetBooleansToFalse() 		{
		}
		#endregion

		public virtual System.Int64? inventory_id		{
			get			{
				return _inventory_id;
			}
			set			{
				if (_inventory_id != value)				{
					_inventory_id = value;
					this.OnPropertyChanged();
				}
			}
		}


		public virtual Lookup owner_id_lookup		{
			get			{
				return _owner_id_lookup;
			}
			set			{
				if (!_owner_id_lookup.IsEqualTo(value))				{
					_owner_id_lookup = value;
					this.OnPropertyChanged();
				}
			}
		}


		[MaxLength(20)]
		public virtual System.String make		{
			get			{
				return _make;
			}
			set			{
				if (_make != value)				{
					_make = value;
					this.OnPropertyChanged();
				}
			}
		}


		[MaxLength(50)]
		public virtual System.String serial_no		{
			get			{
				return _serial_no;
			}
			set			{
				if (_serial_no != value)				{
					_serial_no = value;
					this.OnPropertyChanged();
				}
			}
		}


		public virtual System.DateTime? in_date		{
			get			{
				return _in_date;
			}
			set			{
				if (_in_date != value)				{
					_in_date = value;
					this.OnPropertyChanged();
				}
			}
		}


		public virtual System.DateTime? out_date		{
			get			{
				return _out_date;
			}
			set			{
				if (_out_date != value)				{
					_out_date = value;
					this.OnPropertyChanged();
				}
			}
		}


		public virtual System.Int32? is_deparment_item		{
			get			{
				return _is_deparment_item;
			}
			set			{
				if (_is_deparment_item != value)				{
					_is_deparment_item = value;
					this.OnPropertyChanged();
				}
			}
		}


		public virtual System.Int32? total_parts_count		{
			get			{
				return _total_parts_count;
			}
			set			{
				if (_total_parts_count != value)				{
					_total_parts_count = value;
					this.OnPropertyChanged();
				}
			}
		}


		[MaxLength(250)]
		public virtual System.String remarks		{
			get			{
				return _remarks;
			}
			set			{
				if (_remarks != value)				{
					_remarks = value;
					this.OnPropertyChanged();
				}
			}
		}


		public virtual Lookup program_id_lookup		{
			get			{
				return _program_id_lookup;
			}
			set			{
				if (!_program_id_lookup.IsEqualTo(value))				{
					_program_id_lookup = value;
					this.OnPropertyChanged();
				}
			}
		}


		public override string Id { get { return Convert.ToString(inventory_id); }  }

	}
}

//HASH:17811487209198149108538519218610871192261