package logintest.dao;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import login.model.ShortCut;
import login.model.StartMenu;
import login.model.VersionModel;
import sysManager.user.model.UserModel;

public interface LoginDAO {
    public UserModel login(UserModel user);

}
