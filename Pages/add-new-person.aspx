<%@ Page Language="vb" AutoEventWireup="false" MasterPageFile="~/Site.Master" CodeBehind="add-new-person.aspx.vb" Inherits="sunday_school_ms.add_new_person" %>

<asp:Content ID="headContent" ContentPlaceHolderID="head" runat="server">
    <title>Add New Person</title>
</asp:Content>

<asp:Content ID="bodyContent" ContentPlaceHolderID="MainContent" runat="server">
    <div class="menu-container">
        <div class="right-menu-container">
            <div class="filter-menu">
                <h4>添加新的老师/家长</h4>
            </div>
            <hr />
            <h6>请输入老师/家长的资料。</h6>
            <div class="form-container">
                <p>个人信息</p>
                <!-- First Name -->
                <div class="form-field">
                    <label for="firstName">姓名(英)<span style="color: red;">*</span></label>
                    <div class="input-validation-wrapper">
                        <asp:TextBox ID="TxtFirstName" runat="server"
                            CssClass="textbox-size"
                            ToolTip="Given Name"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckFirstName" runat="server"
                            ErrorMessage="请填写名字。(不包含姓氏)"
                            ControlToValidate="TxtFirstName"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <br />
                <!-- Last Name -->
                <div class="form-field">
                    <label for="lastName">姓氏(英)<span style="color: red;">*</span></label>
                    <div class="input-validation-wrapper">
                        <asp:TextBox ID="TxtLastName" runat="server"
                            CssClass="textbox-size"
                            ToolTip="Family Name"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="CheckLastName" runat="server"
                            ErrorMessage="请输入姓氏。"
                            ControlToValidate="TxtLastName"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <br />
                <!-- Chinese Name -->
                <div class="form-field">
                    <label for="chineseName">姓名(中)</label>
                    <div class="input-validation-wrapper">
                        <asp:TextBox ID="TxtChineseName" runat="server"
                            CssClass="textbox-size"
                            ToolTip="Chinese Name"></asp:TextBox>
                    </div>
                </div>
                <br />
                <!-- Contact Number -->
                <div class="form-field">
                    <label for="contactNo">联络号码<span style="color: red;">*</span></label>
                    <div class="input-validation-wrapper">
                        <asp:TextBox ID="TxtContactNo" runat="server"
                            CssClass="textbox-size"
                            Placeholder="0129876543"></asp:TextBox>
                        <asp:RequiredFieldValidator ID="checkContactNo" runat="server"
                            ErrorMessage="必须填写联络号码。"
                            ControlToValidate="TxtContactNo"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                        <asp:RegularExpressionValidator ID="RvTxtContactNo" runat="server"
                            ErrorMessage="格式不正确，请重新输入。"
                            ControlToValidate="TxtContactNo"
                            ValidationExpression="^\d{10,12}$"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RegularExpressionValidator>
                    </div>
                </div>
                <br />
                <!-- Email -->
                <div class="form-field">
                    <label for="email">电邮</label>
                    <div class="input-validation-wrapper">
                        <asp:TextBox ID="TxtEmail" runat="server"
                            CssClass="textbox-size"
                            Placeholder="example@email.com"></asp:TextBox>
                        <asp:RegularExpressionValidator ID="RevEmail" runat="server"
                            ControlToValidate="TxtEmail"
                            ErrorMessage="请填写有效的邮箱地址(如：johndoe@gmail.com)"
                            ValidationExpression="\w+([-+.']\w+)*@\w+([-.]\w+)*\.\w+([-.]\w+)*"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RegularExpressionValidator>
                    </div>
                </div>
                <br />
                <!-- Gender -->
                <div class="form-field">
                    <label for="gender">性别<span style="color: red;">*</span></label>
                    <div class="input-validation-wrapper">
                        <asp:RadioButtonList ID="RblGender" runat="server"
                            GroupName="gender"
                            RepeatDirection="Horizontal"
                            RepeatLayout="Flow"
                            CssClass="pill-radio">
                            <asp:ListItem>女</asp:ListItem>
                            <asp:ListItem>男</asp:ListItem>
                        </asp:RadioButtonList>
                        <asp:RequiredFieldValidator ID="CheckGender" runat="server"
                            ErrorMessage="请选择性别。"
                            ControlToValidate="RblGender"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                    </div>
                </div>
                <br />
                <!-- Date of Birth -->
                <div class="form-field">
                    <label for="dateOfBirth">出生日期</label>
                    <div class="input-validation-wrapper">
                        <asp:TextBox ID="TxtDateOfBirth" runat="server"
                            CssClass="textbox-size"
                            TextMode="Date"></asp:TextBox>
                        <asp:CustomValidator ID="CvDateOfBirthYearOnly" runat="server"
                            ControlToValidate="TxtDateOfBirth"
                            ClientValidationFunction="ValidateDOBYearOnly"
                            ErrorMessage="年龄必须为 13 岁或以上。"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ValidationGroup="RequiredFieldValidate">
                        </asp:CustomValidator>
                    </div>
                </div>

                <br />
                <p>地址</p>
                <!-- Street Address -->
                <div class="form-field">
                    <label for="streetAddress">街道地址</label>
                    <asp:TextBox ID="TxtStreetAddress" runat="server" CssClass="textbox-size"></asp:TextBox>
                </div>
                <br />
                <!-- City -->
                <div class="form-field">
                    <label for="city">城市</label>
                    <asp:TextBox ID="TxtCity" runat="server" CssClass="textbox-size"></asp:TextBox>
                </div>
                <br />
                <!-- Postcode -->
                <div class="form-field">
                    <label for="postcode">邮政编码</label>
                    <asp:TextBox ID="TxtPostcode" runat="server" CssClass="textbox-size"></asp:TextBox>
                </div>
                <br />
                <!-- State -->
                <div class="form-field">
                    <label for="State">州 / 省</label>
                    <asp:TextBox ID="TxtState" runat="server" CssClass="textbox-size"></asp:TextBox>
                </div>
                <br />
                <!-- Country -->
                <div class="form-field">
                    <label for="Country">国家</label>
                    <asp:TextBox ID="TxtCountry" runat="server" CssClass="textbox-size"></asp:TextBox>
                </div>
                <br />

                <!-- 3. User Type Selection -->
                <p>请选择身份(可选一个或两个)</p>
                <div class="form-field">
                    <label for="CblUserType">这是一位<span style="color: red;">*</span></label>
                    <div class="input-validation-wrapper">
                        <asp:CheckBoxList ID="CblUserType" runat="server"
                            RepeatDirection="Horizontal"
                            RepeatLayout="Flow"
                            ClientIDMode="Static"
                            CssClass="checkbox-inline">
                            <asp:ListItem>老师</asp:ListItem>
                            <asp:ListItem>家长</asp:ListItem>
                        </asp:CheckBoxList>
                        <asp:CustomValidator ID="CvUserType" runat="server"
                            ErrorMessage="请选择一个或两个身份。"
                            CssClass="validator-font"
                            Display="Dynamic"
                            ClientIDMode="Static"
                            EnableClientScript="True"
                            ClientValidationFunction="validateUserType"
                            ValidationGroup="RequiredFieldValidate"
                            OnServerValidate="CvUserType_ServerValidate">
                        </asp:CustomValidator>
                    </div>
                </div>
                <br />
                <!-- Teacher Section -->
                <div id="divTeacherSection" runat="server" class="form-inner-section" style="display: none;" ClientIDMode="Static">
                    <p>老师信息</p>
                    <!-- Role -->
                    <div class="form-field">
                        <label for="Role">角色<span style="color: red;">*</span></label>
                        <div class="input-validation-wrapper">
                            <asp:RadioButtonList ID="RblRole" runat="server"
                                DataSourceID="SqlDataSource_Roles"
                                DataTextField="role_chinese"
                                DataValueField="role_english"
                                CssClass="pill-radio"
                                RepeatDirection="Horizontal"
                                RepeatLayout="Flow">
                            </asp:RadioButtonList>
                            <asp:RequiredFieldValidator ID="CheckRole" runat="server"
                                ErrorMessage="请选择角色。"
                                ControlToValidate="RblRole"
                                CssClass="validator-font"
                                Display="Dynamic"
                                ClientIDMode="Static"
                                ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <br />
                    <!-- Service Type -->
                    <div class="form-field">
                        <label for="ServiceType">事奉项目<span style="color: red;">*</span></label>
                        <div class="input-validation-wrapper">
                            <asp:CheckBoxList ID="CblServiceType" runat="server"
                                RepeatDirection="Horizontal"
                                RepeatLayout="Table"
                                RepeatColumns="4"
                                CssClass="checkbox-multi"
                                AutoPostBack="False"
                                ClientIDMode="Static"
                                onchange="toggleServiceTypeTextbox();"
                                DataSourceID="SqlDataSource_serviceList"
                                DataTextField="service_type"
                                DataValueField="serviceList_id">
                            </asp:CheckBoxList>
                            <div>
                                <asp:TextBox ID="TxtServiceType" runat="server" Text="其他"
                                    CssClass="input-size" Width="400px"
                                    Placeholder="请用逗号分隔(例如:司机, 摄影师)"
                                    Style="display: none;"
                                    ClientIDMode="Static"></asp:TextBox>
                                <asp:RequiredFieldValidator ID="CheckTxtServiceType" runat="server"
                                    ControlToValidate="TxtServiceType"
                                    ErrorMessage="如有其他事奉，请说明…"
                                    ToolTip="请用逗号分隔每种事奉项目"
                                    CssClass="validator-font"
                                    Display="static"
                                    ClientIDMode="Static"
                                    ValidationGroup="RequiredFieldValidate">
                                </asp:RequiredFieldValidator>
                            </div>
                        </div>
                    </div>
                    <br />
                    <!-- Service Start Date -->
                    <div class="form-field">
                        <label for="serviceStartDate">开始事奉的日期<span style="color: red;">*</span></label>
                        <div class="input-validation-wrapper">
                            <asp:TextBox ID="TxtServiceStartDate" runat="server" CssClass="textbox-size"
                                TextMode="Date"></asp:TextBox>
                            <asp:RequiredFieldValidator ID="rvserviceStartDate" runat="server"
                                ErrorMessage="请选择开始事奉的日期。"
                                ControlToValidate="TxtServiceStartDate"
                                CssClass="validator-font"
                                Display="Dynamic"
                                ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                            <asp:RangeValidator ID="RvTxtServiceStartDate" runat="server"
                                ControlToValidate="TxtServiceStartDate"
                                ErrorMessage="事奉开始日期必须是 2000 年 1 月 1 日或之后。"
                                MinimumValue="2000-01-01"
                                MaximumValue="9999-12-31"
                                Type="Date"
                                Display="Dynamic"
                                ClientIDMode="Static"
                                CssClass="validator-font"
                                ValidationGroup="RequiredFieldValidate"></asp:RangeValidator>
                        </div>
                    </div>
                    <br />
                </div>
                <br />
                <!-- Guardian Section -->
                <div id="divGuardianSection" runat="server" class="form-inner-section" style="display: none;" ClientIDMode="Static">
                    <p>家长信息</p>
                    <!-- Child Dropdown -->
                    <div class="form-field">
                        <label for="DdlChild">孩子<span style="color: red;">*</span></label>
                        <div class="input-validation-wrapper">
                            <asp:DropDownList ID="DdlChild" runat="server" CssClass="textbox-size"
                                DataSourceID="SqlDataSource_Children"
                                DataTextField="full_name"
                                DataValueField="child_id"
                                AppendDataBoundItems="true">
                                <asp:ListItem Text="- 请选择孩子名字 -" Value=""></asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="CheckChild" runat="server"
                                ErrorMessage="请选择孩子名字。"
                                ControlToValidate="DdlChild"
                                InitialValue=""
                                CssClass="validator-font"
                                Display="Dynamic"
                                ClientIDMode="Static"
                                ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <br />
                    <!-- Relationship Dropdown -->
                    <div class="form-field">
                        <label for="DdlRelationship">关系<span style="color: red;">*</span></label>
                        <div class="input-validation-wrapper">
                            <asp:DropDownList ID="DdlRelationship" runat="server"
                                CssClass="textbox-size">
                                <asp:ListItem Text="" Value=""></asp:ListItem>
                                <asp:ListItem Text="母亲" Value="母亲"></asp:ListItem>
                                <asp:ListItem Text="父亲" Value="父亲"></asp:ListItem>
                                <asp:ListItem Text="婆婆/外婆" Value="婆婆"></asp:ListItem>
                                <asp:ListItem Text="公公/外公" Value="公公"></asp:ListItem>
                                <asp:ListItem Text="其他" Value="其他"></asp:ListItem>
                            </asp:DropDownList>
                            <asp:RequiredFieldValidator ID="CheckRelationship" runat="server"
                                ErrorMessage="请选择关系。"
                                ControlToValidate="DdlRelationship"
                                CssClass="validator-font"
                                Display="Dynamic"
                                ClientIDMode="Static"
                                ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <br />
                    <!-- Religion Radio Button -->
                    <div class="form-field">
                        <label for="RblReligion">信仰<span style="color: red;">*</span></label>
                        <div class="input-validation-wrapper">
                            <asp:RadioButtonList ID="RblReligion" runat="server"
                                RepeatDirection="Horizontal"
                                RepeatLayout="Flow"
                                CssClass="pill-radio">
                                <asp:ListItem Text="基督徒"></asp:ListItem>
                                <asp:ListItem Text="非基督徒"></asp:ListItem>
                            </asp:RadioButtonList>
                            <asp:RequiredFieldValidator ID="CheckReligion" runat="server"
                                ErrorMessage="请选择信仰。"
                                ControlToValidate="RblReligion"
                                CssClass="validator-font"
                                Display="Dynamic"
                                ClientIDMode="Static"
                                ValidationGroup="RequiredFieldValidate"></asp:RequiredFieldValidator>
                        </div>
                    </div>
                    <br />
                </div>
                    <br />
                    <!-- Buttons -->
                    <div class="btn-form-align">
                        <asp:Button ID="BtnConfirm" runat="server" Text="确认资料"
                            CssClass="btn-insert" ClientIDMode="Static"
                            ValidationGroup="RequiredFieldValidate"
                            CausesValidation="True" />
                        <asp:Button ID="BtnCancel" runat="server" Text="取消"
                            CssClass="btn-cancel" ClientIDMode="Static"
                            OnClientClick="return confirm('取消操作后，所有未保存的数据都将丢失。您确定吗？');" />
                    </div>
            </div>
        </div>
    </div>

    <asp:SqlDataSource ID="SqlDataSource_Roles" runat="server"
        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
        SelectCommand="
        SELECT DISTINCT 
            role AS role_english,
        CASE 
            WHEN role = 'Principal' THEN '校长'
            WHEN role = 'Teacher' THEN '老师'
            WHEN role = 'Teaching Assistants' THEN '助教'
            ELSE role
        END AS role_chinese
        FROM staff
        ORDER BY role_english"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource_serviceList" runat="server"
        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
        SelectCommand="SELECT serviceList_id, service_type FROM [serviceList]"></asp:SqlDataSource>
    <asp:SqlDataSource ID="SqlDataSource_Children" runat="server"
        ConnectionString="<%$ ConnectionStrings:SundaySchDBConnection %>"
        SelectCommand="
        SELECT child_id, (chinese_name + '(' + first_name + ' ' + last_name +')') AS full_name 
        FROM child WHERE isArchive = 0 ORDER BY full_name"></asp:SqlDataSource>

        <script>
            // ----------------------------
            // 1. DOB Validation
            // ----------------------------
            function ValidateDOBYearOnly(sender, args) {
                if (!args.Value) {
                    args.IsValid = false; // empty field is invalid
                    return;
                }

                // Parse the input date
                var inputDate = new Date(args.Value);
                if (isNaN(inputDate.getTime())) {
                    args.IsValid = false; // invalid date format
                    return;
                }

                var birthYear = inputDate.getFullYear();
                var currentYear = new Date().getFullYear();

                var age = currentYear - birthYear;

                args.IsValid = (age >= 13);
            }

            // ----------------------------
            // 2. Toggle Teacher/Guardian Sections
            // ----------------------------
            Sys.Application.add_load(function () {
                const userTypeCheckboxes = document.querySelectorAll('#CblUserType input[type=checkbox]');
                const teacherDiv = document.getElementById('divTeacherSection');
                const guardianDiv = document.getElementById('divGuardianSection');
                function toggleSections() {
                    let teacherSelected = false;
                    let guardianSelected = false;
                    userTypeCheckboxes.forEach((chk, index) => {
                        if (index === 0) teacherSelected = chk.checked;   // 老师
                        if (index === 1) guardianSelected = chk.checked;  // 家长
                    });
                    teacherDiv.style.display = teacherSelected ? 'block' : 'none';
                    guardianDiv.style.display = guardianSelected ? 'block' : 'none';
                }
                userTypeCheckboxes.forEach(chk => chk.addEventListener('change', toggleSections));
                toggleSections();
            });
            function validateUserType(source, args) {
                const userTypeCheckboxes = document.querySelectorAll('#CblUserType input[type=checkbox]');
                let teacherSelected = userTypeCheckboxes[0]?.checked || false;
                let guardianSelected = userTypeCheckboxes[1]?.checked || false;

                let totalSelected = (teacherSelected ? 1 : 0) + (guardianSelected ? 1 : 0);
                args.IsValid = (totalSelected >= 1 && totalSelected <= 2);

                console.log('Validation - teacher:', teacherSelected, 'guardian:', guardianSelected, 'valid:', args.IsValid);
            }

            // ----------------------------
            // 3. Toggle "Others" Service Textbox
            // ----------------------------
            // Function to toggle textbox for checkbox option 'others'
            function toggleServiceTypeTextbox() {
                var checkboxes = document.querySelectorAll('#<%= CblServiceType.ClientID %> input[type=checkbox]');
                var txt = document.getElementById('TxtServiceType');
                var othersChecked = false;

                checkboxes.forEach(function (chk) {
                    var parentLabel = chk.parentNode;
                    if (parentLabel && parentLabel.innerText.trim().indexOf('其他') !== -1 && chk.checked) {
                        othersChecked = true;
                    }
                });

                var validator = document.getElementById('CheckTxtServiceType');

                if (othersChecked) {
                    txt.style.display = 'inline-block';

                    // Enable validator but don't force validation now
                    if (validator) {
                        ValidatorEnable(validator, true);
                    }
                } else {
                    txt.style.display = 'none';
                    txt.value = ''; // reset if unchecked

                    if (validator) {
                        ValidatorEnable(validator, false);
                        ValidatorValidate(validator);
                    }
                }
            }

            function validateOnSubmit() {        // Function to validate on Confirm button click
                var checkboxes = document.querySelectorAll('#<%= CblServiceType.ClientID %> input[type=checkbox]');
                var txt = document.getElementById('TxtServiceType');
                var othersChecked = false;

                checkboxes.forEach(function (chk) {
                    var parentLabel = chk.parentNode;
                    if (parentLabel && parentLabel.innerText.trim().indexOf('其他') !== -1 && chk.checked) {
                        othersChecked = true;
                    }
                });

                var validator = document.getElementById('CheckTxtServiceType');

                if (othersChecked && txt.value.trim() === '') {
                    // Show validation error
                    if (validator) {
                        ValidatorEnable(validator, true);
                        ValidatorValidate(validator);
                        return false; // Prevent form submission
                    }
                } else {
                    if (validator) {
                        ValidatorEnable(validator, false);
                        ValidatorValidate(validator);
                    }
                }
                return true; // Allow form submission
            }

            <%--document.addEventListener('DOMContentLoaded', function () {
                var checkboxes = document.querySelectorAll('#<%= CblServiceType.ClientID %> input[type=checkbox]');
                checkboxes.forEach(function (chk) {
                    chk.addEventListener('change', toggleServiceTypeTextbox);
                });
                toggleServiceTypeTextbox(); // Run on page load

                var btnConfirm = document.getElementById('BtnConfirm');
                if (btnConfirm) {
                    btnConfirm.addEventListener('click', function (e) {
                        if (!validateOnSubmit()) {
                            e.preventDefault(); // Stop submission if validation fails
                        }
                    });
                }
            });--%>



        </script>

</asp:Content>
