<template>
	<el-main class="bg edit_wrap comtable_e">
		<el-form ref="form" :rules="rules" :model="form" status-icon label-width="120px" v-if="is_view()">
		<el-row class="row_ce"> 
	            <el-col :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
                <el-form-item label="封面图" prop="cart_avatar">
                    <el-upload class="avatar-uploader" drag accept="image/gif, image/jpeg, image/png, image/jpg"
                               action="" :http-request="upload_cart_img" :show-file-list="false">
                        <img id="cart_img" v-if="form.cart_img" :src="$fullUrl(form.cart_img)" class="avatar">
                        <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                    </el-upload>
                </el-form-item>
            </el-col>

            <el-col :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
                <el-form-item label="主图_1" prop="cart_avatar">
                    <el-upload class="avatar-uploader" drag accept="image/gif, image/jpeg, image/png, image/jpg"
                               action="" :http-request="upload_cart_img_1" :show-file-list="false">
                        <img id="cart_img_1" v-if="form.cart_img_1" :src="$fullUrl(form.cart_img_1)" class="avatar">
                        <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                    </el-upload>
                </el-form-item>
            </el-col>

            <el-col :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
                <el-form-item label="主图_2" prop="cart_avatar">
                    <el-upload class="avatar-uploader" drag accept="image/gif, image/jpeg, image/png, image/jpg"
                               action="" :http-request="upload_cart_img_2" :show-file-list="false">
                        <img id="cart_img_2" v-if="form.cart_img_2" :src="$fullUrl(form.cart_img_2)" class="avatar">
                        <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                    </el-upload>
                </el-form-item>
            </el-col>

            <el-col :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
                <el-form-item label="主图_3" prop="cart_avatar">
                    <el-upload class="avatar-uploader" drag accept="image/gif, image/jpeg, image/png, image/jpg"
                               action="" :http-request="upload_cart_img_3" :show-file-list="false">
                        <img id="cart_img_3" v-if="form.cart_img_3" :src="$fullUrl(form.cart_img_3)" class="avatar">
                        <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                    </el-upload>
                </el-form-item>
            </el-col>

            <el-col :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
                <el-form-item label="主图_4" prop="cart_avatar">
                    <el-upload class="avatar-uploader" drag accept="image/gif, image/jpeg, image/png, image/jpg"
                               action="" :http-request="upload_cart_img_4" :show-file-list="false">
                        <img id="cart_img_4" v-if="form.cart_img_4" :src="$fullUrl(form.cart_img_4)" class="avatar">
                        <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                    </el-upload>
                </el-form-item>
            </el-col>

            <el-col :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
                <el-form-item label="主图_5" prop="cart_avatar">
                    <el-upload class="avatar-uploader" drag accept="image/gif, image/jpeg, image/png, image/jpg"
                               action="" :http-request="upload_cart_img_5" :show-file-list="false">
                        <img id="cart_img_5" v-if="form.cart_img_5" :src="$fullUrl(form.cart_img_5)" class="avatar">
                        <i v-else class="el-icon-plus avatar-uploader-icon"></i>
                    </el-upload>
                </el-form-item>
            </el-col>

            <el-col :xs="24" :sm="12" :lg="12" class="el_form_item_warp">
                <el-form-item label="标题" prop="cart_title">
                    <el-input v-model="form.cart_title" placeholder="请输入标题"></el-input>
                </el-form-item>
            </el-col>

            <el-col :xs="24" :sm="12" :lg="12" class="el_form_item_warp">
                <el-form-item label="描述" prop="cart_description">
                    <el-input v-model="form.cart_description" placeholder="请输入描述"></el-input>
                </el-form-item>
            </el-col>

            <el-col :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
                <el-form-item label="原价" prop="cart_price_ago">
                    <el-input-number v-model="form.cart_price_ago"></el-input-number>
                </el-form-item>
            </el-col>

		
            <el-col :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
                <el-form-item label="卖价" prop="cart_price">
                    <el-input-number v-model="form.cart_price"></el-input-number>
                </el-form-item>
            </el-col>

            <el-col :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
                <el-form-item label="库存" prop="cart_inventory">
                    <el-input-number v-model="form.cart_inventory" placeholder="请输入库存"></el-input-number>
                </el-form-item>
            </el-col>

            <el-col :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
                <el-form-item label="分类" prop="cart_type">
                    <el-select v-model="form.cart_type">
                        <el-option v-for="(o ,i) in list_cart_goods_type" :value="o.name" :key="i"
                                   :label="o.name"></el-option>
                    </el-select>
                </el-form-item>
            </el-col>
							<el-col v-if="$check_field('get','seller_customers') || $check_field('add','seller_customers') || $check_field('set','seller_customers')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="卖家用户" prop="seller_customers">
																					<div v-if="user_group !== '管理员'">
							{{ get_user_session_seller_customers(form['seller_customers']) }}
							<el-select v-if="(form['cultural_and_creative_mall_id'] && $check_field('set','seller_customers')) || (!form['cultural_and_creative_mall_id'] && $check_field('add','seller_customers'))" id="seller_customers" v-model="form['seller_customers']" :disabled="disabledObj['seller_customers_isDisabled']">
								<el-option v-for="o in list_user_seller_customers" :key="o['username']" :label="o['nickname'] + '-' + o['username']"
										   :value="o['user_id']">
								</el-option>
							</el-select>
							<el-select v-else-if="$check_field('get','seller_customers')" id="seller_customers" v-model="form['seller_customers']" :disabled="true">
								<el-option v-for="o in list_user_seller_customers" :key="o['username']" :label="o['nickname'] + '-' + o['username']"
										   :value="o['user_id']">
								</el-option>
							</el-select>
						</div>
						<el-select v-else id="seller_customers" v-model="form['seller_customers']" :disabled="disabledObj['seller_customers_isDisabled']">
							<el-option v-for="o in list_user_seller_customers" :key="o['username']" :label="o['nickname'] + '-' + o['username']"
									   :value="o['user_id']">
							</el-option>
						</el-select>
																</el-form-item>
			</el-col>
								<el-col v-if="$check_field('get','personnel_name') || $check_field('add','personnel_name') || $check_field('set','personnel_name')" :xs="24" :sm="12" :lg="8" class="el_form_item_warp">
							<el-form-item label="人员姓名" prop="personnel_name">
															<el-input id="personnel_name" v-model="form['personnel_name']" placeholder="请输入人员姓名"
							  v-if="(form['cultural_and_creative_mall_id'] && $check_field('set','personnel_name')) || (!form['cultural_and_creative_mall_id'] && $check_field('add','personnel_name'))" :disabled="disabledObj['personnel_name_isDisabled']"></el-input>
					<div v-else-if="$check_field('get','personnel_name')">{{form['personnel_name']}}</div>
											</el-form-item>
			</el-col>
			<el-col v-if="$check_field('get','product_specifications') || $check_field('add','product_specifications') || $check_field('set','product_specifications')" :xs="24" :sm="24" :lg="24" class="el_form_item_warp">
				<el-form-item label="商品规格" prop="product_specifications">
					<div v-if="(form['cultural_and_creative_mall_id'] && $check_field('set','product_specifications')) || (!form['cultural_and_creative_mall_id'] && $check_field('add','product_specifications'))">
						<div class="spec-editor-header">
							<el-button type="primary" size="mini" @click="addSpecGroup">新增分类</el-button>
						</div>
						<div v-for="(group, gIdx) in specification_groups" :key="'group-'+gIdx" class="spec-group-card">
							<div class="spec-group-row">
								<el-input v-model="group.name" placeholder="分类名称（如 颜色、尺码）" class="spec-group-name"></el-input>
								<el-button size="mini" @click="moveSpecGroup(gIdx, -1)" :disabled="gIdx===0">上移</el-button>
								<el-button size="mini" @click="moveSpecGroup(gIdx, 1)" :disabled="gIdx===specification_groups.length-1">下移</el-button>
								<el-button size="mini" type="danger" @click="removeSpecGroup(gIdx)">删除分类</el-button>
							</div>
							<div v-for="(opt, oIdx) in group.options" :key="'opt-'+gIdx+'-'+oIdx" class="spec-option-row">
								<el-input v-model="group.options[oIdx].value" placeholder="属性值（如 红色、XL）" class="spec-option-input"></el-input>
								<div class="spec-price-editor">
									<el-button size="mini" @click="changeSpecPrice(gIdx, oIdx, -1)" :disabled="gIdx !== 0">-</el-button>
									<el-input
										:value="group.options[oIdx].price"
										@input="setSpecPrice(gIdx, oIdx, $event)"
										:disabled="gIdx !== 0"
										class="spec-price-input"
										:placeholder="gIdx === 0 ? '成交价' : '仅首分类可定价'"
									></el-input>
									<el-button size="mini" @click="changeSpecPrice(gIdx, oIdx, 1)" :disabled="gIdx !== 0">+</el-button>
								</div>
								<el-button size="mini" @click="moveSpecOption(gIdx, oIdx, -1)" :disabled="oIdx===0">上移</el-button>
								<el-button size="mini" @click="moveSpecOption(gIdx, oIdx, 1)" :disabled="oIdx===group.options.length-1">下移</el-button>
								<el-button size="mini" plain type="primary" @click="addSpecOption(gIdx, oIdx)">新增属性</el-button>
								<el-button size="mini" type="danger" @click="removeSpecOption(gIdx, oIdx)">删除属性</el-button>
							</div>
						</div>
					</div>
					<div v-else-if="$check_field('get','product_specifications')">{{ renderSpecGroupText(form['product_specifications']) }}</div>
				</el-form-item>
			</el-col>
						
	
	
		
		
	
	
	
	            <el-col :xs="24" :sm="24" :lg="24" class="el_form_editor_warp">
                <el-form-item label="正文" prop="cart_content">
                    <quill-editor v-model="form.cart_content">
                    </quill-editor>
                </el-form-item>
            </el-col>
	
		</el-row>
			<el-col :xs="24" :sm="12" :lg="8" class="el_form_btn_warp">
				<el-form-item v-if="$check_action('/cultural_and_creative_mall/view','set') || $check_action('/cultural_and_creative_mall/view','add') || $check_option('/cultural_and_creative_mall/table','examine')">
					<el-button type="primary" @click="submitCheckNew">提交</el-button>
					<el-button @click="cancel()">取消</el-button>
				</el-form-item>
				<el-form-item v-else>
					<el-button @click="cancel()">返回</el-button>
				</el-form-item>
			</el-col>

		</el-form>
	</el-main>
</template>

<script>
	import mixin from "@/mixins/page.js";
	export default {
		mixins: [mixin],
		data() {
			return {
				field: "cultural_and_creative_mall_id",
				url_add: "~/api/cultural_and_creative_mall/add?",
				url_set: "~/api/cultural_and_creative_mall/set?",
				url_get_obj: "~/api/cultural_and_creative_mall/get_obj?",
				url_upload: "~/api/cultural_and_creative_mall/upload?",

				query: {
					"cultural_and_creative_mall_id": 0,
				},

				form: {
								"seller_customers": 0, // 卖家用户
										"personnel_name":  '', // 人员姓名
										"product_specifications":  '', // 商品规格
						                    cart_title: "",
                    cart_img: "",
                    cart_description: "",
		                    cart_price_ago: 0,
                    cart_price: 0,
                    cart_inventory: 0,
                    cart_type: '',
                    cart_content: "",
                    cart_img_1: "",
                    cart_img_2: "",
                    cart_img_3: "",
                    cart_img_4: "",
                    cart_img_5: "",
						"cultural_and_creative_mall_id": 0, // ID
													},
				specification_groups: [],
				disabledObj:{
								"seller_customers_isDisabled": false,
										"personnel_name_isDisabled": false,
										"product_specifications_isDisabled": false,
										},

	
					// 用户列表
				list_user_seller_customers: [],
						// 用户组
				group_user_seller_customers: "",
					
			
		                list_cart_goods_type: [],
				goods_form:{
					goods_id: 0,
					title: "",
					img: "",
					description: "",
					price_ago: 0,
					price: 0,
					inventory: 0,
						type: '',
					content: "",
					img_1: "",
					img_2: "",
					img_3: "",
					img_4: "",
					img_5: "",
					source_table: "",
					source_field: "",
					source_id: 0,
					user_id:this.$store.state.user.user_id
				},
				rules:{
					"cart_title": [
						{required: true, message: '请输入标题', trigger: 'blur'},
					],
					"cart_description": [
						{required: true, message: '请输入描述', trigger: 'blur'},
					],
					"cart_price_ago": [
						{required: true, message: '请输入原价', trigger: 'blur'},
					],
						"cart_price": [
						{required: true, message: '请输入卖价', trigger: 'blur'},
					],
					"cart_inventory": [
						{required: true, message: '请输入库存', trigger: 'blur'},
					],
					"cart_type": [
						{required: true, message: '请选择分类', trigger: 'change'},
					],
					"cart_content": [
						{required: true, message: '请输入正文', trigger: 'blur'},
					]
				}

			}
		},
		methods: {

	
	
				/**
			 * 获取传承用户用户列表
			 */
			async get_list_user_seller_customers() {
                var json = await this.$get("~/api/user/get_list?user_group=传承用户");
                if(json.result && json.result.list){
                    this.list_user_seller_customers = json.result.list;
                }
                else if(json.error){
                    console.error(json.error);
                }
			},
					/**
			 * 获取传承用户用户组
			 */
			async get_group_user_seller_customers() {
							this.form["seller_customers"] = this.user.user_id;
							var json = await this.$get("~/api/user_group/get_obj?name=传承用户");
				if(json.result && json.result.obj){
					this.group_user_seller_customers = json.result.obj;
				}
				else if(json.error){
					console.error(json.error);
				}
			},
			get_user_session_seller_customers(id){
				var _this = this;
				var user_id = {"user_id":id}
				var url = "~/api/"+_this.group_user_seller_customers.source_table+"/get_obj?"
				this.$get(url, user_id, function(res) {
					if (res.result && res.result.obj) {
						var arr = []
						for (let key in res.result.obj) {
							arr.push(key)
						}
						var arrForm = []
									for (let key in _this.form) {
							arrForm.push(key)
						}
												_this.form["seller_customers"] = id
									_this.disabledObj['seller_customers' + '_isDisabled'] = true
						for (var i=0;i<arr.length;i++){
						  if (arr[i]!=='examine_state' && arr[i]!=='examine_reply') {
							for (var j = 0; j < arrForm.length; j++) {
							  if (arr[i] === arrForm[j]) {
								if (arr[i] !== "seller_customers") {
			                      _this.form[arrForm[j]] = res.result.obj[arr[i]]
			                      _this.disabledObj[arrForm[j] + '_isDisabled'] = true
								  break;
								} else {
								  _this.disabledObj[arrForm[j] + '_isDisabled'] = true
								}
							  }
							}
						  }
						}
					}
				});
			},
					get_user_seller_customers(id){
				var obj = this.list_user_seller_customers.getObj({"user_id":id});
				var ret = "";
				if(obj){
					if(obj.nickname){
						ret = obj.nickname;}
					else{
						ret = obj.username;
					}
				}
				return ret;
			},
			
	
			
	
		
			/**
			 * 获取对象之前
			 * @param {Object} param
			 */
			get_obj_before(param) {
				var form = "";
							
				if(this.form && form){
					Object.keys(this.form).forEach(key => {
						Object.keys(form).forEach(dbKey => {
							// if(dbKey === "charging_standard"){
							// 	this.form['charging_rules'] = form[dbKey];
							// 	this.disabledObj['charging_rules_isDisabled'] = true;
							// };
							if(key === dbKey){
								this.disabledObj[key+'_isDisabled'] = true;
								this.form[key] = form[dbKey]
							}
							if(dbKey === "source_table"){
								this.form['source_table'] = form[dbKey];
							}
							if(dbKey === "source_id"){
								this.form['source_id'] = form[dbKey];
							}
							if(dbKey === "source_user_id"){
								this.form['source_user_id'] = form[dbKey];
							}
						})
					})
				}
										$.db.del("form");

				return param;
			},

			/**
			 * 获取对象之后
			 * @param {Object} json
			 * @param {Object} func
			 */
			get_obj_after(json, func){
				this.syncSpecificationGroupsFromForm();
				const sourceId = this.form[this.field];
				if (sourceId) {
					this.$get("~/api/goods/get_obj?", {
						source_table: "cultural_and_creative_mall",
						source_field: this.field,
						source_id: sourceId
					}, (res) => {
						if (res && res.result && res.result.obj && res.result.obj.customize_field) {
							const list = this.parseCustomizeFieldList(res.result.obj.customize_field);
							const specItem = list.find(item => item.field_name === "商品规格" && item.type === "spec_schema");
							if (specItem && specItem.field_value) {
								this.specification_groups = this.parseSpecificationGroups(specItem.field_value);
							}
						}
					});
				}
			},

																											async submit(param, func){
				if (!param) {
					param = this.form;
				}
						
				var pm = this.events("submit_before", Object.assign({}, param)) || param;
				var msg = await this.events("submit_check", pm);
				var ret;
				if (msg) {
					this.$toast(msg, 'danger');
				} else {
																													ret = this.events("submit_main", pm, func);
				}
				return ret;
			},
			
			/**
			 * 提交前验证事件
			 * @param {Object} 请求参数
			 * @return {String} 验证成功返回null, 失败返回错误提示
			 */
			submit_check(param) {
				const normalized = this.specification_groups
					.map(group => ({
						name: String(group.name || "").trim(),
						options: (group.options || []).map(v => this.normalizeSpecOption(v)).filter(v => v.value)
					}))
					.filter(group => group.name && group.options.length > 0);
				if (normalized.length) {
					const firstGroup = normalized[0];
					for (let j = 0; j < firstGroup.options.length; j++) {
						const opt = firstGroup.options[j];
						if (!Number.isFinite(Number(opt.price)) || Number(opt.price) <= 0) {
							return "已设置规格时，第一分类下每个属性都必须填写大于0的成交价";
						}
					}
				}
				param.product_specifications = this.buildSpecSummary(64);
																																	return null;
			},
			syncSpecificationGroupsFromForm(){
				this.specification_groups = this.parseSpecificationGroups(this.form.product_specifications);
			},
			parseSpecificationGroups(raw){
				if(!raw){
					return [];
				}
				try{
					const parsed = JSON.parse(raw);
					if(Array.isArray(parsed)){
						return parsed.map((group)=>({
							name: String((group && group.name) || "").trim(),
							options: Array.isArray(group && group.options)
								? group.options.map(v => this.normalizeSpecOption(v)).filter(v => v.value)
								: []
						}));
					}
				}catch(e){
					// old plain-text compatibility
				}
				const text = String(raw).trim();
				if(!text){
					return [];
				}
				// legacy plain-text data: initialize as blank placeholders so users can directly type without deleting.
				return [{ name: "", options: [this.defaultSpecOption()] }];
			},
			defaultSpecOption(){
				return { value: "", stock: 0, price: Number(this.form.cart_price || 0) };
			},
			normalizeSpecOption(raw){
				if (typeof raw === "string") {
					return { value: raw.trim(), stock: 0, price: Number(this.form.cart_price || 0) };
				}
				const value = String((raw && raw.value) || "").trim();
				const stock = Number.isFinite(Number(raw && raw.stock)) ? Math.max(0, parseInt(raw.stock, 10)) : 0;
				const price = Number.isFinite(Number(raw && raw.price)) ? Math.max(0, Number(raw.price)) : Number(this.form.cart_price || 0);
				return { value, stock, price };
			},
			parseCustomizeFieldList(raw){
				try{
					const parsed = JSON.parse(raw);
					return Array.isArray(parsed) ? parsed : [];
				}catch(e){
					return [];
				}
			},
			serializeSpecificationGroups(){
				const normalized = this.specification_groups
					.map((group, groupIdx) => ({
						name: String(group.name || "").trim(),
						options: (group.options || [])
							.map(v => this.normalizeSpecOption(v))
							.map(v => groupIdx === 0 ? v : ({ ...v, price: 0 }))
							.filter(v => v.value)
					}))
					.filter(group => group.name && group.options.length > 0);
				return normalized.length ? JSON.stringify(normalized) : "";
			},
			buildSpecSummary(maxLen = 64){
				const normalized = this.specification_groups
					.map(group => ({
						name: String(group.name || "").trim(),
						options: (group.options || [])
							.map(v => this.normalizeSpecOption(v))
							.filter(v => v.value)
					}))
					.filter(group => group.name && group.options.length > 0);
				if (!normalized.length) {
					return "";
				}
				let summary = normalized.map(group => `${group.name}:${group.options.map(o => o.value).join("/")}`).join("；");
				if (summary.length > maxLen) {
					summary = summary.slice(0, maxLen);
				}
				return summary;
			},
			renderSpecGroupText(raw){
				const groups = this.parseSpecificationGroups(raw);
				if(!groups.length){
					return "";
				}
				return groups.map(g => `${g.name}: ${g.options.join(" / ")}`).join("；");
			},
			addSpecGroup(){
				this.specification_groups.push({ name: "", options: [this.defaultSpecOption()] });
			},
			removeSpecGroup(groupIdx){
				this.specification_groups.splice(groupIdx, 1);
			},
			moveSpecGroup(groupIdx, step){
				const target = groupIdx + step;
				if(target < 0 || target >= this.specification_groups.length){
					return;
				}
				const list = this.specification_groups;
				const tmp = list[groupIdx];
				this.$set(list, groupIdx, list[target]);
				this.$set(list, target, tmp);
			},
			addSpecOption(groupIdx, optionIdx){
				if(typeof optionIdx === "number"){
					this.specification_groups[groupIdx].options.splice(optionIdx + 1, 0, this.defaultSpecOption());
					return;
				}
				this.specification_groups[groupIdx].options.push(this.defaultSpecOption());
			},
			removeSpecOption(groupIdx, optionIdx){
				this.specification_groups[groupIdx].options.splice(optionIdx, 1);
			},
			moveSpecOption(groupIdx, optionIdx, step){
				const opts = this.specification_groups[groupIdx].options;
				const target = optionIdx + step;
				if(target < 0 || target >= opts.length){
					return;
				}
				const tmp = opts[optionIdx];
				this.$set(opts, optionIdx, opts[target]);
				this.$set(opts, target, tmp);
			},
			setSpecPrice(groupIdx, optionIdx, val){
				if (groupIdx !== 0) {
					return;
				}
				const num = Number(val);
				const next = Number.isFinite(num) ? Math.max(0, num) : 0;
				this.specification_groups[groupIdx].options[optionIdx].price = Number(next.toFixed(2));
			},
			changeSpecPrice(groupIdx, optionIdx, delta){
				if (groupIdx !== 0) {
					return;
				}
				const current = Number(this.specification_groups[groupIdx].options[optionIdx].price || 0);
				const next = Math.max(0, current + delta);
				this.specification_groups[groupIdx].options[optionIdx].price = Number(next.toFixed(2));
			},

			is_view(){
				// var bl = this.user_group == "管理员";
				var bl = false;

				if(!bl){
					bl = this.$check_action('/cultural_and_creative_mall/table','add');
					console.log(bl ? "你有表格添加权限视作有添加权限" : "你没有表格添加权限");
				}
				if(!bl){
					bl = this.$check_action('/cultural_and_creative_mall/table','set');
					console.log(bl ? "你有表格添加权限视作有修改权限" : "你没有表格修改权限");
				}
				if(!bl){
					bl = this.$check_action('/cultural_and_creative_mall/view','add');
					console.log(bl ? "你有视图添加权限视作有添加权限" : "你没有视图添加权限");
				}
				if(!bl){
					bl = this.$check_action('/cultural_and_creative_mall/view','set');
					console.log(bl ? "你有视图修改权限视作有修改权限" : "你没有视图修改权限");
				}
				if(!bl){
					bl = this.$check_action('/cultural_and_creative_mall/view','get');
					console.log(bl ? "你有视图查询权限视作有查询权限" : "你没有视图查询权限");
				}

				console.log(bl ? "具有当前页面的查看权，请注意这不代表你有字段的查看权" : "无权查看当前页，请注意即便有字段查询权限没有页面查询权限也不行");

				return bl;
			},
			submitCheckNew(){
				let that=this;
				if(this.user.user_group !== "管理员" && Number(this.form.seller_customers) !== Number(this.user.user_id)){
					this.$toast("仅管理员和该商品上传传承用户可编辑", "error");
					return false;
				}
				if(!this.form.cart_img){
					this.$toast("请上传封面图","error");
					return false;
				}
				this.$refs["form"].validate((valid) => {
					if (valid) {
						// 使用mixin里的submit方法
						that.events("submit")
					} else {
						console.error('error 提交失败!!');
					}
				});
			},
            /**
             * 获取商品分类
             */
            async get_cart_goods_type() {
                var res = await this.$get("~/api/goods_type/get_list?");
                this.list_cart_goods_type = res.result.list;
            },
            /**
             * 上传封面图
             * @param {Object} param
             */
            upload_cart_img(param) {
                this.uploadFile(param.file, "cart_img");
            },

            /**
             * 上传文件
             * @param {Object} param
             */
            upload_cart_img_1(param) {
                this.uploadFile(param.file, "cart_img_1");
            },

            /**
             * 上传文件
             * @param {Object} param
             */
            upload_cart_img_2(param) {
                this.uploadFile(param.file, "cart_img_2");
            },

            /**
             * 上传文件
             * @param {Object} param
             */
            upload_cart_img_3(param) {
                this.uploadFile(param.file, "cart_img_3");
            },

            /**
             * 上传文件
             * @param {Object} param
             */
            upload_cart_img_4(param) {
                this.uploadFile(param.file, "cart_img_4");
            },

            /**
             * 上传文件
             * @param {Object} param
             */
            upload_cart_img_5(param) {
                this.uploadFile(param.file, "cart_img_5");
            },

            submit_after(){
                console.log(this.form[this.field])
                if (this.form[this.field]){
                    this.submit_goods(this.form[this.field],"set");
                } else {
                    let query_form = {
                        cart_title:this.form.cart_title,
                        cart_description:this.form.cart_description
                    }
                    this.$get("~/api/cultural_and_creative_mall/get_obj?",query_form,(res)=>{
                        console.log("商品息res",res);
                        if(res.result && res.result.obj){
                            this.submit_goods(res.result.obj[this.field],"add");
                        }else if(res.error){
                            console.error(res.error);
                            this.$toast(res.error.message,"error");
                        }
                    })
                }
            },
            submit_goods(source_id,add_flag){
				const fullSpecSchema = this.serializeSpecificationGroups();
				this.form.product_specifications = this.buildSpecSummary(64);
				let customize_field = []
							customize_field.push({"field_name":"卖家用户","field_value":this.form.seller_customers,"type":"uid"});
									customize_field.push({"field_name":"人员姓名","field_value":this.form.personnel_name});
									customize_field.push({"field_name":"商品规格","field_value":fullSpecSchema, "type":"spec_schema"});
			                this.goods_form = {
                    goods_id: 0,
                    title: this.form.cart_title,
                    img: this.form.cart_img,
                    description: this.form.cart_description,
                    price_ago: this.form.cart_price_ago,
	                    price: this.form.cart_price,
                    inventory: this.form.cart_inventory,
                    type: this.form.cart_type,
                    content: this.form.cart_content,
                    img_1: this.form.cart_img_1,
                    img_2: this.form.cart_img_2,
                    img_3: this.form.cart_img_3,
                    img_4: this.form.cart_img_4,
                    img_5: this.form.cart_img_5,
                    source_table: "cultural_and_creative_mall",
                    source_field: this.field,
                    source_id: source_id,
					customize_field: JSON.stringify(customize_field),
					user_id:this.$store.state.user.user_id
                }
                if (add_flag==='set'){
                    delete this.goods_form.goods_id;
					delete this.goods_form.user_id;
                    // 提交事件
                    this.$post("~/api/goods/set?source_table=cultural_and_creative_mall&source_field=" + this.field + "&source_id=" + source_id,this.goods_form,(res)=>{
                        console.log("提交结果：" ,res)
                        if(res.result){
                            this.$toast("修改成功!" ,"success");
							this.$router.push("/cultural_and_creative_mall/table");
                        }else if(res.error){
                            console.error(res.error);
                            this.$toast(res.error.message,"error");
                        }
                    });
                }else {
                    // 提交事件
                    this.$post("~/api/goods/add?",this.goods_form,(res)=>{
                        console.log("提交结果：" ,res)
                        if(res.result){
                            this.$toast("添加成功!" ,"success");
							this.$router.push("/cultural_and_creative_mall/table");
                        }else if(res.error){
                            console.error(res.error);
                            this.$toast(res.error.message,"error");
                        }
                    });
                }
            },
			/**
			 * 上传文件
			 * @param {Object} param
			 */
			uploadimg(param) {
				this.uploadFile(param.file, "avatar");
			},

		},
		created() {
					this.get_list_user_seller_customers();
					this.get_group_user_seller_customers();
							            this.get_cart_goods_type();
			this.syncSpecificationGroupsFromForm();
		},
		mounted(){
			this.$refs["form"].resetFields();
			this.syncSpecificationGroupsFromForm();
		},
		watch: {
			'form.product_specifications': function() {
				this.syncSpecificationGroupsFromForm();
			}
		}
	}
</script>

<style>
	.avatar-uploader .el-upload {
		border: 1px dashed #d9d9d9;
		border-radius: 6px;
		cursor: pointer;
		position: relative;
		overflow: hidden;
	}

	.avatar-uploader .el-upload:hover {
		border-color: #409EFF;
	}

	.avatar-uploader-icon {
		font-size: 28px;
		color: #8c939d;
		width: 178px;
		height: 178px;
		line-height: 178px;
		text-align: center;
	}

	.avatar {
		width: 178px;
		height: 178px;
		display: block;
	}
	
	.img_multiple{
		overflow: hidden;
	}
	.img_multiple .img_block{
		float: left;
		margin-right: 5px;
		margin-bottom: 5px;
		position: relative;
	}
	.img_multiple .img_block img{
		height: 100px;
		width: auto;
	}
	.img_multiple .img_del{
		position: absolute;
		top: 5px;
		right: 5px;
		width: 20px;
		height: 20px;
		background: #0000008a;
		color: #fff;
		line-height: 20px;
		text-align: center;
		border-radius: 100%;
		cursor: pointer;
	}

	.spec-editor-header {
		margin-bottom: 8px;
	}
	.spec-group-card {
		border: none;
		border-radius: 0;
		padding: 10px;
		margin-bottom: 10px;
		width: 760px;
		max-width: 100%;
	}
	.spec-group-row,
	.spec-option-row {
		display: flex;
		align-items: center;
		gap: 8px;
		margin-bottom: 8px;
	}
	.spec-group-name,
	.spec-option-input {
		width: 300px !important;
	}
	.spec-group-name .el-input__inner,
	.spec-option-input .el-input__inner {
		width: 300px !important;
	}
	.spec-price-editor {
		display: flex;
		align-items: center;
		gap: 6px;
	}
	.spec-price-input {
		width: 150px;
	}




	
</style>
