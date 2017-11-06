package cn.ucmed;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

import javax.servlet.http.HttpServletRequest;

@Controller
@RequestMapping(value = "/configs")
public class SampleDataController {

    @RequestMapping("")
    public String index(ModelMap map) {
        return "config";
    }

    @RequestMapping(method = RequestMethod.POST, value = "/setConfig")
    public ResponseEntity setConfig(HttpServletRequest request) {

        return new ResponseEntity("{}", HttpStatus.OK);
    }
}
