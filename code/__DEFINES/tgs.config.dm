#define TGS_EXTERNAL_CONFIGURATION
#define TGS_DEFINE_AND_SET_GLOBAL(Name, Value) GLOBAL_VAR_INIT(##Name, ##Value); GLOBAL_PROTECT(##Name)
#define TGS_READ_GLOBAL(Name) GLOB.##Name
#define TGS_WRITE_GLOBAL(Name, Value) GLOB.##Name = ##Value
#define TGS_WORLD_ANNOUNCE(message) to_chat(world, "<span class='boldannounce'>[rhtml_encode(##message)]</span>")
#define TGS_INFO_LOG(message) log_world("TGS: Info: [##message]")
#define TGS_ERROR_LOG(message) log_world("TGS: Error: [##message]")
#define TGS_NOTIFY_ADMINS(event) message_admins(##event)
#define TGS_CLIENT_COUNT GLOB.clients.len
#define TGS_PROTECT_DATUM(Path)\
##Path/can_vv_get(var_name){\
    return FALSE;\
}\
##Path/vv_edit_var(var_name, var_value){\
    return FALSE;\
}\
##Path/CanProcCall(procname){\
    return FALSE;\
}
